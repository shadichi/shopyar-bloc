import 'package:flutter/material.dart';
import 'package:shopyar/core/config/app-colors.dart';

class LogInTextFormWidget extends StatelessWidget {
  TextEditingController textEditingController;
  String hintText;
  LogInTextFormWidget(this.textEditingController, this.hintText);

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
    //  color: Colors.red,
      height: AppConfig.calHeight(context, 13),
      width: AppConfig.calWidth(context, 70),
      child: TextFormField(
        controller: textEditingController,
        textInputAction: TextInputAction.next,
        scrollPadding: const EdgeInsets.only(bottom: 100),
        style:  TextStyle(
          color: AppConfig.backgroundColor,
          fontSize: AppConfig.calFontSize(context, 3.7),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.end,
        textAlignVertical: TextAlignVertical.center,
        //keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: false, // دیگه بک‌گراند نداره
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          counterText: "",
          hintText: hintText,
          hintStyle: TextStyle(color: AppConfig.backgroundColor),

          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.grey,
            ),
          ),

          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: AppConfig.progressBarColor,
            ),
          ),

          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),

          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'این فیلد اجباری است';
          }
          return null;
        },
      ),
    );
  }
}
