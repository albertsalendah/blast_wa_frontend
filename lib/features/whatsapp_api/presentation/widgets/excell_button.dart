import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';

class ExcellButton extends StatelessWidget {
  final GlobalKey btnKey;
  final bool visibility;
  final VoidCallback onTap;
  const ExcellButton(
      {super.key,
      required this.btnKey,
      required this.onTap,
      required this.visibility});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 42,
              width: 42,
              child: IconButton(
                key: btnKey,
                hoverColor: AppPallete.borderColor.withAlpha(50),
                color: AppPallete.white,
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppPallete.white),
                  shape: WidgetStateProperty.all(
                    CircleBorder(
                      side: BorderSide(
                        color: AppPallete.borderColor.withAlpha(100),
                      ),
                    ),
                  ),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: onTap,
                icon: Image.asset(
                  'assets/icons/excel.png',
                  scale: 1.6,
                ),
              ),
            ),
          ),
          Visibility(
            visible: visibility,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 22,
                width: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppPallete.green,
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppPallete.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
