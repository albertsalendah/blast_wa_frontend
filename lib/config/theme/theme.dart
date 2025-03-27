import 'package:flutter/material.dart';
import 'app_pallet.dart';

class AppTheme {
  //Example theme
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1),
      );

  static final darkThemeMode = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.only(left: 27),
      hintStyle: TextStyle(
        color: AppPallete.grey,
      ),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.green),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)),
        backgroundColor: WidgetStateProperty.all(AppPallete.green),
        foregroundColor: WidgetStateProperty.all(AppPallete.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppPallete.transparent, width: 1),
          ),
        ),
        elevation: WidgetStateProperty.all(1),
        padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
      ),
    ),
  );
}
