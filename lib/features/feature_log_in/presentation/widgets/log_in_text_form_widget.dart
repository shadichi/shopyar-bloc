import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';

class LogInTextFormWidget extends StatelessWidget {
  TextEditingController textEditingController;
  LogInTextFormWidget(this.textEditingController);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 80,
      child: TextFormField(
        controller: textEditingController,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.end,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 20),
          fillColor: Colors.grey[300],
          counterText: "",
          enabledBorder: OutlineInputBorder(
              borderSide:  BorderSide(
                  width: 2, color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: Colors.transparent),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 1, color: AppConfig.progressBarColor),
              borderRadius: BorderRadius.circular(10)),
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
