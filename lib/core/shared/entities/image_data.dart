import 'dart:typed_data';

class ImageData {
  final String name;
  final Uint8List? byte;
  ImageData({
    required this.name,
    this.byte,
  });
}
