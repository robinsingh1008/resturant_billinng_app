import 'package:flutter/material.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/widgets/app_button.dart';
import 'package:resturent_billinng_app/widgets/app_text_form.dart';

Future<String?> showCustomTextInputBottomSheet({
  required BuildContext context,
  required String title,
  required String hintText,
  String cancelText = 'Cancel',
  String saveText = 'Save',
  String initialValue = '',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CustomTextInputBottomSheet(
        title: title,
        hintText: hintText,
        cancelText: cancelText,
        saveText: saveText,
        initialValue: initialValue,
      );
    },
  );
}

class CustomTextInputBottomSheet extends StatefulWidget {
  const CustomTextInputBottomSheet({
    super.key,
    required this.title,
    required this.hintText,
    this.cancelText = 'Cancel',
    this.saveText = 'Save',
    this.initialValue = '',
  });

  final String title;
  final String hintText;
  final String cancelText;
  final String saveText;
  final String initialValue;

  @override
  State<CustomTextInputBottomSheet> createState() =>
      _CustomTextInputBottomSheetState();
}

class _CustomTextInputBottomSheetState
    extends State<CustomTextInputBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, bottomInset + 0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                contentPadding: EdgeInsets.all(16),

                controller: _controller,
                hintText: "Enter category",
                borderRadius: 11,
                hasBorder: true,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      key: ValueKey("cancel"),
                      buttonText: widget.cancelText,
                      buttonColor: AppColors.textSecondary,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      key: ValueKey("save"),
                      buttonText: widget.saveText,

                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }
}
