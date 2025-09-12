import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shapyar_bloc/core/widgets/alert_dialog.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../data/models/store_info.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterInfData extends StatefulWidget {
  final isFirstTime;
  EnterInfData({this.isFirstTime = false});

  static String routeName = 'EnterInfData';

  @override
  _EnterInfDataState createState() => _EnterInfDataState();
}

class _EnterInfDataState extends State<EnterInfData> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  String path = '';

  File? _imageFile;
  static const _kSavedPathKey = 'saved_image_path';
  final _picker = ImagePicker();

  Future<void> _saveData() async {
    try{
      var box = await Hive.openBox<StoreInfo>('storeBox');
      var storeInfo = StoreInfo(
        storeName: _storeNameController.text,
        storeAddress: _storeAddressController.text,
        phoneNumber: _phoneNumberController.text,
        instagram: _instagramController.text,
        postalCode: _postalCodeController.text,
        website: _websiteController.text,
        storeIcon: path,
      );
      await box.put('storeInfo', storeInfo);
      await box.close();

      showSnack(context, 'اطلاعات برچسب پستی با موفقیت ذخیره شد.');

    }catch(e){
      showSnack(context, 'خطا در ثبت اطلاعات برچسب پستی: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    _loadSavedImage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.isFirstTime) return;
      if(widget.isFirstTime){
        _showIntroDialog();
      }
    });
  }

  /*Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDbFirstTime = prefs.getBool('isDbFirstTime') ?? false;

    if (isDbFirstTime == true) {
      Navigator.pushReplacementNamed(context, '/anotherPage');
    }
  }*/

  Future<void> _showIntroDialog() async {
    final res = await alertDialogScreen(
        context,
        "در این بخش، اطلاعات ارسالی شما برای درج در برچسب پستی دریافت و ذخیره می‌شود.\nمی‌توانید در آینده از طریق صفحه اصلی برنامه آن را ویرایش کنید.",
        1,
        true,
        icon: Icons.announcement);
    if (!context.mounted) return;
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
   path = prefs.getString(_kSavedPathKey).toString();
    if (path.isNotEmpty && File(path).existsSync()) {
      setState(() => _imageFile = File(path));
    }
  }

  Future<void> _pickFromGallery() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    // Copy to app directory so you own the file and it won’t get GC’d by the OS.
    final appDir = await getApplicationDocumentsDirectory();
    final saved = File(
        '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}_${xfile.name}');
    await File(xfile.path).copy(saved.path);

    // Persist path for later
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSavedPathKey, saved.path);

    setState(() => _imageFile = saved);
  }

  Future<void> _clearImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_kSavedPathKey);
    if (path != null) {
      final f = File(path);
      if (await f.exists()) await f.delete();
      await prefs.remove(_kSavedPathKey);
    }
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ثبت اطلاعات برچسب پستی",
          style: TextStyle(
              color: Colors.white,
              fontSize: AppConfig.calTitleFontSize(context)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  label: "نام فروشگاه",
                  controller: _storeNameController,
                  inputFormatter:
                      FilteringTextInputFormatter.allow(RegExp(r'[آ-ی 0-9.,a-z]')),
                  validator: (value) =>
                      value!.isEmpty ? "نام فروشگاه را وارد کنید" : null,
                ),
                CustomTextField(
                  label: "آدرس فروشگاه",
                  controller: _storeAddressController,
                  inputFormatter:
                      FilteringTextInputFormatter.allow(RegExp(r'[آ-ی 0-9.,a-z]')),
                  validator: (value) =>
                      value!.isEmpty ? "آدرس فروشگاه را وارد کنید" : null,
                ),
                CustomTextField(
                  label: "شماره تلفن",
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  validator: (value) =>
                      (value!.length < 10) ? "شماره تلفن معتبر نیست" : null,
                ),
                CustomTextField(
                  label: "اینستاگرام",
                  controller: _instagramController,
                  validator: (value) => value!.isEmpty
                      ? "لطفاً نام کاربری اینستاگرام را وارد کنید"
                      : null,
                ),
                CustomTextField(
                  label: "کد پستی",
                  controller: _postalCodeController,
                  keyboardType: TextInputType.number,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  validator: (value) =>
                      (value!.length != 10) ? "کد پستی باید ۱۰ رقم باشد" : null,
                ),
                CustomTextField(
                  label: "وبسایت",
                  controller: _websiteController,
                  inputFormatter:
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z ,0-9.,آ-ی]')),
                  validator: (value) =>
                      value!.isEmpty ? "وبسایت را وارد کنید" : null,
                ),

                SizedBox(height: AppConfig.calHeight(context, 1)),
                Container(
                  //color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: AppConfig.calWidth(context, 40),
                        height: AppConfig.calHeight(context, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            //   _saveData();
                            //   Navigator.pushNamed(context, '/pdfViewer');
                            _pickFromGallery();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConfig.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    AppConfig.calBorderRadiusSize(context))),
                                side: BorderSide(
                                    width: 1, color: Colors.grey[300]!),
                              )),
                          child: Text(
                            _imageFile == null
                                ? 'انتخاب آیکون از گالری'
                                : 'تغییر آیکون',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConfig.calFontSize(context, 3)),
                          ),
                        ),
                      ),

                      Center(
                        child: _imageFile == null
                            ? Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppConfig.calBorderRadiusSize(
                                                context)))),
                          height: AppConfig.calHeight(context, 10),
                          width: AppConfig.calWidth(context, 25),
                                child: Text(
                                  'آیکونی انتخاب نشده',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          AppConfig.calFontSize(context, 2.5)),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppConfig.calBorderRadiusSize(context)),
                                child: Image.file(
                                  _imageFile!,
                                  height: AppConfig.calHeight(context, 10),
                                  width: AppConfig.calWidth(context, 25),
                                  fit: BoxFit
                                      .cover, // looks like an uploaded preview
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppConfig.calHeight(context, 5),),
                Container(
                  width: AppConfig.calWidth(context, 73),
                  height: AppConfig.calHeight(context, 6),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if(_imageFile != null){
                          _saveData();
                          Navigator.pushNamed(context, '/pdfViewer');
                        }else{
                          alertDialogScreen(context, 'لطفا یک آیکون انتخاب کنید.', 0, false);
                        }

                      }
                     // _clearImage();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(width: 1, color: Colors.grey[300]!),
                        )),
                    child: Text(
                      'ذخیره',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConfig.calFontSize(context, 3)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.inputFormatter,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(fontSize: AppConfig.calFontSize(context, 3.2)),
          filled: true,
          fillColor: Colors.grey[100],
          errorStyle: TextStyle(
              fontSize: AppConfig.calFontSize(context, 3),
              fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueGrey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}

class IconChooser extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;
  final String? Function(String?)? validator;

  const IconChooser({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.inputFormatter,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: AppConfig.calWidth(context, 30),
            height: AppConfig.calHeight(context, 10),
            color: Colors.grey,
            child: Text('انتخاب آیکون از گالری'),
          ),
          Container(
            width: AppConfig.calWidth(context, 30),
            height: AppConfig.calHeight(context, 10),
            color: Colors.grey,
            child: Text('انتخاب آیک.ن از گالری'),
          )
        ],
      ),
    );
  }
}
