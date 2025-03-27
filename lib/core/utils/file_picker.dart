import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';

Future<List<ImageData>> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowCompression: true,
    withReadStream: true,
    compressionQuality: 30,
    allowedExtensions: [
      'jpg',
      'png',
      'jpeg',
    ],
  );
  try {
    if (result != null) {
      return Future.wait(
        result.files.map((e) async {
          if (kIsWeb) {
            if (e.readStream != null) {
              Uint8List bytes = Uint8List.fromList(await e.readStream!.reduce(
                (previous, element) => previous + element,
              ));
              return ImageData(name: e.name, byte: bytes);
            } else {
              throw Exception("Stream is null for file: ${e.name}");
            }
          } else {
            File? file = e.path != null ? File(e.path!) : null;
            if (file != null) {
              return ImageData(name: e.name, byte: await file.readAsBytes());
            } else {
              throw Exception("File is null");
            }
          }
        }),
      );
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<PlatformFile?> pickExcel() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['xlsx', 'csv'],
  );
  return result?.files.first;
}
