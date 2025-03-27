import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';

class QrButton extends StatelessWidget {
  final bool visibility;
  final VoidCallback onTap;
  const QrButton({
    super.key,
    required this.visibility,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: Stack(
        children: [
          IconButton(
            hoverColor: AppPallete.borderColor.withAlpha(50),
            style: ButtonStyle(
              shape: WidgetStateProperty.all(CircleBorder()),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.all(AppPallete.white),
            ),
            icon: Icon(Icons.qr_code, color: AppPallete.green),
            onPressed: onTap,
          ),
          IgnorePointer(
            ignoring: true,
            child: Visibility(
              visible: visibility,
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.red,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
