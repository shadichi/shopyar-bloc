import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';

void showSnack(
    BuildContext context,
    String message, {
      Color? color,
      Duration duration = const Duration(seconds: 3),
      SnackBarAction? action,
    }) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: AppConfig.calFontSize(context, 3),
        ),
      ),
      backgroundColor: color ?? AppConfig.secondaryColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      action: action,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.calBorderRadiusSize(context)),
      ),
      margin:  EdgeInsets.symmetric(horizontal: AppConfig.calWidth(context, 3), vertical: AppConfig.calWidth(context, 3)),
    ),
  );
}
