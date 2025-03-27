import 'package:flutter/material.dart';

import '../../../config/theme/app_pallet.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppPallete.green,
      ),
    );
  }
}
