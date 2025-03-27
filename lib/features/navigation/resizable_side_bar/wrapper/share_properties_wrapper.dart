import 'package:flutter/material.dart';
import 'share_properties_injector.dart';

class ResizableSidebarSharedPropertiesWrapper extends StatelessWidget {
  final double? iconSize;
  final Color? iconColor;
  final double? fontSize;
  final Color? selectedMenuBackgroundColor;
  final Color? hoverColor;
  final Color? menuBackgroundColor;
  final TextStyle? textStyle;
  final Widget child;

  const ResizableSidebarSharedPropertiesWrapper({
    super.key,
    this.iconSize,
    this.iconColor,
    this.fontSize,
    this.selectedMenuBackgroundColor,
    this.hoverColor,
    this.menuBackgroundColor,
    this.textStyle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResizableSharedPropertiesInjector(
      iconSize: iconSize,
      iconColor: iconColor,
      fontSize: fontSize,
      selectedMenuBackgroundColor: selectedMenuBackgroundColor,
      hoverColor: hoverColor,
      menuBackgroundColor: menuBackgroundColor,
      textStyle: textStyle,
      child: child,
    );
  }
}
