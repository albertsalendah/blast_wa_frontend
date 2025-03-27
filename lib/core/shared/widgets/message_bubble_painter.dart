import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';

class MessageBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppPallete.darkGreen;
    final path = Path();

    // Draw the tail
    path.moveTo(size.width - 50, 0);
    path.lineTo(size.width + 12, 0);
    path.quadraticBezierTo(size.width + 20, 0, size.width - 24,
        size.height > 50 ? 30 : size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
