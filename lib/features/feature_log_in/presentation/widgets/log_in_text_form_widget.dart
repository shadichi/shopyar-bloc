import 'package:flutter/material.dart';
import 'package:shopyar/core/config/app-colors.dart';

class LogInTextFormWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hint;

  LogInTextFormWidget(this.textEditingController, this.hint);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConfig.calHeight(context, 10),
      child: TextFormField(
        controller: textEditingController,
        textDirection: TextDirection.ltr,
        textInputAction: TextInputAction.next,
        scrollPadding: const EdgeInsets.only(bottom: 100),

        style: TextStyle(
          color: AppConfig.backgroundColor,
          fontSize: AppConfig.calFontSize(context, 3.7),
          fontWeight: FontWeight.bold,
        ),

        decoration: InputDecoration(
          hintText: hint,
          hintTextDirection: TextDirection.rtl,
          filled: true,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          fillColor: Colors.grey[300],
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: AppConfig.progressBarColor,
            ),
            borderRadius: BorderRadius.circular(10),
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
