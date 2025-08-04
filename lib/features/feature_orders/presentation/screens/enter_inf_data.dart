import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../../../../core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../../data/models/store_info.dart';

class EnterInfData extends StatefulWidget {
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
  final TextEditingController _storeIconController = TextEditingController();

  Future<void> _saveData() async {
    var box = await Hive.openBox<StoreInfo>('storeBox');
    var storeInfo = StoreInfo(
      storeName: _storeNameController.text,
      storeAddress: _storeAddressController.text,
      phoneNumber: _phoneNumberController.text,
      instagram: _instagramController.text,
      postalCode: _postalCodeController.text,
      website: _websiteController.text,
      storeIcon: _storeIconController.text,
    );
    await box.put('storeInfo', storeInfo);
    await box.close();
  }

  void _showWelcomeDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("📢 اطلاعیه",style: TextStyle(fontSize: AppConfig.calTitleFontSize(context)),),
            content: Text(
              "در این بخش، اطلاعات ارسالی شما برای درج در برچسب پستی دریافت و ذخیره می‌شود.\n"
              "می‌توانید در آینده از طریق صفحه اصلی برنامه آن را ویرایش کنید.",style: TextStyle(fontSize: AppConfig.calTitleFontSize(context)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("متوجه شدم ✅",style: TextStyle(color: Colors.black87,fontSize: AppConfig.calTitleFontSize(context)),),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _showWelcomeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        title: Text(
          "ثبت اطلاعات برچسب پستی",
          style: TextStyle(color: Colors.white,fontSize: AppConfig.calTitleFontSize(context)),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppConfig.background,
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
                      FilteringTextInputFormatter.allow(RegExp(r'[آ-ی ]')),
                  validator: (value) =>
                      value!.isEmpty ? "نام فروشگاه را وارد کنید" : null,
                ),
                CustomTextField(
                  label: "آدرس فروشگاه",
                  controller: _storeAddressController,
                  inputFormatter:
                      FilteringTextInputFormatter.allow(RegExp(r'[آ-ی 0-9.,]')),
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
                      FilteringTextInputFormatter.allow(RegExp(r'[آ-ی 0-9.,]')),
                  validator: (value) =>
                      value!.isEmpty ? "وبسایت را وارد کنید" : null,
                ),
                CustomTextField(
                  label: "آیکون فروشگاه",
                  controller: _storeIconController,
                  keyboardType: TextInputType.number,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  validator: (value) =>
                      value!.isEmpty ? "آیکون فروشگاه را وارد کنید" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveData();
                      Navigator.pushNamed(context, '/pdfViewer');
                    }
                  },
                  child: Text("ذخیره",style: TextStyle(color: Colors.black,fontSize: AppConfig.calTitleFontSize(context)),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ویجت اختصاصی برای تکست فیلدها 🚀
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
          hintStyle: TextStyle(fontSize: AppConfig.calTitleFontSize(context) ),
          filled: true,
          fillColor: Colors.grey[100],
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
