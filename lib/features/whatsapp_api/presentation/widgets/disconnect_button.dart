import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';

class DisconnectButton extends StatelessWidget {
  final bool visibility;
  final int numConnected;
  final VoidCallback onTap;
  const DisconnectButton({
    super.key,
    required this.visibility,
    required this.numConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: IconButton(
                    hoverColor: AppPallete.borderColor.withAlpha(50),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(CircleBorder()),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          WidgetStateProperty.all(AppPallete.white),
                    ),
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: onTap,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IgnorePointer(
                  child: Container(
                    height: 16,
                    width: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppPallete.green,
                    ),
                    child: Text(
                      numConnected.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppPallete.white,
                          fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
