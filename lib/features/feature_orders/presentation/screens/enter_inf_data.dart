import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shopyar/core/widgets/alert_dialog.dart';
import 'package:shopyar/features/feature_orders/domain/entities/orders_entity.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../data/models/store_info.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../widgets/show_post_label.dart';

class EnterInfData extends StatefulWidget {
  final isFirstTime;
  final ordersEntity;
  final bool isFromDrawer;
  EnterInfData({this.isFirstTime = false, this.ordersEntity, this.isFromDrawer = false});

  static String routeName = 'EnterInfData';

  @override
  _EnterInfDataState createState() => _EnterInfDataState();
}

class _EnterInfDataState extends State<EnterInfData> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeSenderNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String path = '';

  File? _imageFile;
  static const _kSavedPathKey = 'saved_image_path';
  final _picker = ImagePicker();
  var storeInfo = StoreInfo(storeName: '', storeAddress: '', phoneNumber: '', instagram: '', postalCode: '', website: '', storeIcon: '');

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
        storeSenderName: _storeSenderNameController.text,
        storeNote: _noteController.text

      );
      await box.put('storeInfo', storeInfo);
    //  await box.close();

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

  Future<String> persistIcon(Uint8List bytes, {String originalName = 'icon.png'}) async {
    final dir = await getApplicationDocumentsDirectory(); // مسیر داخلی اپ
    final ext = p.extension(originalName.isEmpty ? 'icon.png' : originalName);
    final file = File(p.join(dir.path, 'store_icon$ext')); // مثلا .../app_flutter/store_icon.png
    await file.writeAsBytes(bytes, flush: true);
    return file.path; // این مسیر رو تو Hive ذخیره کن
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
   path = prefs.getString(_kSavedPathKey).toString();
    if (path.isNotEmpty && File(path).existsSync()) {
      setState(() => _imageFile = File(path));
    }
    var box = await Hive.openBox<StoreInfo>('storeBox');
    var tempStoreInfo = box.get('storeInfo');
    if (tempStoreInfo != null) {
      storeInfo = tempStoreInfo;
      if (storeInfo.storeName.isNotEmpty) {
        _storeNameController.text = storeInfo.storeName;
        _storeAddressController.text = storeInfo.storeAddress;
        _phoneNumberController.text = storeInfo.phoneNumber;
        _instagramController.text = storeInfo.instagram;
        _postalCodeController.text = storeInfo.postalCode;
        _websiteController.text = storeInfo.website;
        path = storeInfo.storeIcon;
        _storeSenderNameController.text = storeInfo.storeSenderName ?? '';
        _noteController.text = storeInfo.storeNote ?? '';
      }
    }

  }

  Future<void> _pickFromGallery() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final ext = p.extension(xfile.name);
    final file = File(p.join(appDir.path, 'store_icon${ext.isEmpty ? '.png' : ext}'));

// مستقیم کپی کن (کم‌مصرف‌تر از readAsBytes)
    await xfile.saveTo(file.path);

    print('file.path');
    print(file.path);

    path = file.path;

// ذخیره مسیر
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSavedPathKey, file.path);

    setState(() => _imageFile = file);

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
                  label: "نام فرستنده",
                  controller: _storeSenderNameController,
                  inputFormatter:
                  FilteringTextInputFormatter.allow(RegExp(r'[آ-ی 0-9.,a-z]')),
                  validator: (value) =>
                  value!.isEmpty ? "نام فرستنده را وارد کنید" : null,
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
                  validator:  null,
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
                  validator:  null,
                ),
                CustomTextField(
                  label: "یادداشت",
                  controller: _noteController,
                  inputFormatter:
                  FilteringTextInputFormatter.allow(RegExp(r'[a-z ,0-9.,آ-ی]')),
                  validator: null,
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
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConfig.calFontSize(context, 3.5)),
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
                                          AppConfig.calFontSize(context, 3.5)),
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
                          if(!widget.isFromDrawer){
                            orderPostLabelPDF(
                              widget.ordersEntity!,
                            );
                          }

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
                          fontSize: AppConfig.calFontSize(context, 4.2)),
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
        style: TextStyle(
            fontSize: AppConfig.calFontSize(context, 3.2)
        ),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,

          hintStyle: TextStyle(fontSize: AppConfig.calFontSize(context, 4)),
          filled: true,
          fillColor: Colors.grey[100],
          errorStyle: TextStyle(
              fontSize: AppConfig.calFontSize(context, 3),
              fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blueGrey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: AppConfig.firstLinearColor, width: 2),
          ),
        ),
      ),
    );
  }
}

