import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';

class ProgressBar extends StatelessWidget {
  final Color color;
  final double size;
   ProgressBar({
    super.key,
    this.color = AppConfig.progressBarColor,
    this.size = 5
  });
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: AppConfig.calWidth(context, size),
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: color,
          ),
        );
      },
    );
  }
}



