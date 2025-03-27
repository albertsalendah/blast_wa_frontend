import 'package:flutter/material.dart';

Image imageBackgound({required BuildContext context}) {
  return Image.asset('assets/images/background.png',
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover);
}
