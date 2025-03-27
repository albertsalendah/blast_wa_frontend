import 'package:flutter/material.dart';

import '../../config/theme/app_pallet.dart';

void showSnackBarError({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(color: AppPallete.white),
        ),
        showCloseIcon: true,
        closeIconColor: AppPallete.white,
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: AppPallete.error,
      ),
    );
}

void showSnackBarSuccess({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          style: TextStyle(color: AppPallete.white),
        ),
        showCloseIcon: true,
        closeIconColor: AppPallete.white,
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: AppPallete.green,
      ),
    );
}
