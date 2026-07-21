// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';

// import 'package:ticket_clippers/ticket_clippers.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? disabledColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final double elevation;
  final String? image;
  final double? imageSize;
  final double? scalSize;

  const CircleButton({
    required super.key,

    this.onPressed,
    this.buttonColor,
    this.disabledColor,
    this.width,
    this.height,
    this.borderRadius = 11,
    this.elevation = 1,
    this.image,
    this.imageSize = 25,
    this.scalSize = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height ?? 50,
          width: width ?? double.infinity,
          decoration: BoxDecoration(
            color: buttonColor ?? AppColors.primary,

            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: elevation,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: Image.asset(image!, scale: scalSize)),
        ),
      ),
    );
  }
}
