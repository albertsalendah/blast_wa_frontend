import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';

class ColoredDot extends StatelessWidget {
  final ConnectionStatus isConnected;
  const ColoredDot({
    super.key,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isConnected != ConnectionStatus.connecting,
      replacement: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          color: AppPallete.green,
        ),
      ),
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: isConnected == ConnectionStatus.open
              ? AppPallete.green
              : AppPallete.error,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
