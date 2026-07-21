// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double iconHeight;
  final double? borderRadius;
  final double elevation;
  final bool? showRow;
  final Color? borderColor;
  final String? icon;
  final String? name;
  final bool? showicon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontweight;
  final bool? showstaricon;
  final Gradient? gradient;
  final double paddingleft;
  final double paddingright;
  final double paddingtop;
  final double paddingbottom;

  const ChipButton({
    required super.key,
    this.showRow,
    this.showicon,
    this.borderColor,
    this.onPressed,
    this.width,
    this.height,
    this.iconHeight = 24,
    this.borderRadius,
    this.icon,
    this.name,
    this.elevation = 1,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontweight,
    this.showstaricon,
    this.gradient,
    this.paddingleft = 4,
    this.paddingbottom = 4,
    this.paddingright = 4,
    this.paddingtop = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heightsize = MediaQuery.of(context).size.height;
    final resolvedHeight = height ?? (showRow == true ? 35.0 : 44.0);
    final resolvedTextColor = textColor ?? theme.colorScheme.onPrimary;

    return GestureDetector(
      // onTap: onPressed,
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Container(
        width: width,
        height: resolvedHeight,
        padding: EdgeInsets.only(
          left: paddingleft,
          right: paddingright,
          top: paddingtop,
          bottom: paddingbottom,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: backgroundColor ?? theme.colorScheme.onInverseSurface,
          // color: backgroundColor ?? Colors.white,
          gradient: gradient,
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: showstaricon == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        name.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: resolvedTextColor,
                          fontWeight: fontweight ?? FontWeight.w600,
                          fontSize: fontSize ?? 10,
                        ),
                      ),
                    ),
                  ),
                  if (showicon == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Image.asset(icon.toString(), height: iconHeight),
                    ),
                ],
              )
            : showRow == true
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showicon == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Image.asset(icon.toString(), height: iconHeight),
                    ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, left: 4),
                      child: Text(
                        name.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: resolvedTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize ?? 10,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showicon == true)
                    Image.asset(icon.toString(), height: iconHeight),
                  if (showicon == true) SizedBox(height: heightsize * 0.004),
                  Flexible(
                    child: Text(
                      name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: resolvedTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize ?? 10,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
