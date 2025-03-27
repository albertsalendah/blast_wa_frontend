import 'package:flutter/material.dart';

class ResizableSharedPropertiesInjector extends InheritedWidget {
  final double? iconSize;
  final Color? iconColor;
  final double? fontSize;
  final Color? selectedMenuBackgroundColor;
  final Color? hoverColor;
  final Color? menuBackgroundColor;
  final TextStyle? textStyle;

  const ResizableSharedPropertiesInjector({
    super.key,
    this.iconSize,
    this.iconColor,
    this.fontSize,
    this.selectedMenuBackgroundColor,
    this.hoverColor,
    this.menuBackgroundColor,
    this.textStyle,
    required super.child,
  });

  static ResizableSharedPropertiesInjector of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        ResizableSharedPropertiesInjector>()!;
  }

  @override
  bool updateShouldNotify(ResizableSharedPropertiesInjector oldWidget) {
    return iconSize != oldWidget.iconSize ||
        iconColor != oldWidget.iconColor ||
        fontSize != oldWidget.fontSize ||
        selectedMenuBackgroundColor != oldWidget.selectedMenuBackgroundColor ||
        hoverColor != oldWidget.hoverColor ||
        menuBackgroundColor != oldWidget.menuBackgroundColor ||
        textStyle != oldWidget.textStyle;
  }
}
