import 'package:flutter/material.dart';

class LabeledFormField extends StatelessWidget {
  final String label;
  final Widget child;
  final TextStyle? labelStyle;
  final double? spacing;

  const LabeledFormField({
    super.key,
    required this.label,
    required this.child,
    this.labelStyle,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle ?? theme.textTheme.bodyMedium),
        SizedBox(height: spacing ?? size.height * 0.01),
        child,
      ],
    );
  }
}
