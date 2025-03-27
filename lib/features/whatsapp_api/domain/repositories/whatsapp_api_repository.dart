import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/phone_number.dart';

abstract interface class WhatsappApiRepository {
  Future<Either<Failure, List<PhoneNumber>>> getPhoneNumbers(
      {required String email});
  Future<Either<Failure, DioResponse>> sendmessage({
    required PlatformFile excelFile,
    required List<ImageData> listImages,
    required String email,
    required String noWA,
    required String message,
    required String countryCode,
  });
}
