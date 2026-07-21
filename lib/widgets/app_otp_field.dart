import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AppPinCodeField extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final FormFieldValidator<String>? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? cursorColor;
  final double fieldHeight;
  final double fieldWidth;

  const AppPinCodeField({
    super.key,
    required this.controller,
    this.length = 6,
    this.obscureText = false,
    this.onChanged,
    this.onCompleted,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.cursorColor,
    this.fieldHeight = 50,
    this.fieldWidth = 50,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    final Color effectiveBorderColor =
        borderColor ??
        inputTheme.border?.borderSide.color ??
        colorScheme.primary;
    final Color activeBorderColor = borderColor ?? colorScheme.primary;
    final Color effectiveFillColor =
        fillColor ?? inputTheme.fillColor ?? colorScheme.surface;
    final Color effectiveTextColor =
        textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: PinCodeTextField(
        appContext: context,
        length: length,
        obscureText: obscureText,
        animationType: AnimationType.fade,
        cursorHeight: 20,
        cursorColor: cursorColor ?? activeBorderColor,
        controller: controller,
        autoDisposeControllers: false,
        keyboardType: TextInputType.number,
        enableActiveFill: true,
        animationDuration: const Duration(milliseconds: 250),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: fieldHeight,
          fieldWidth: fieldWidth,
          borderWidth: 0,
          inactiveColor: effectiveBorderColor,
          activeColor: effectiveBorderColor,
          selectedColor: activeBorderColor,
          activeFillColor: effectiveFillColor,
          inactiveFillColor: effectiveFillColor,
          selectedFillColor: effectiveFillColor,
        ),
        textStyle: theme.textTheme.bodyLarge?.copyWith(
          color: effectiveTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.transparent,
        validator: validator,
        onChanged: onChanged,
        onCompleted: onCompleted,
        beforeTextPaste: (text) => true,
      ),
    );
  }
}
