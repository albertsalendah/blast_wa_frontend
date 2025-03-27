import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/exceptions.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/features/whatsapp_api/data/datasources/web_socket_remote_data_source.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/phone_number.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/repositories/whatsapp_api_repository.dart';

class WhatsappApiRepositoryImpl implements WhatsappApiRepository {
  final WebSocketRemoteDataSource remoteDataSource;
  WhatsappApiRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, List<PhoneNumber>>> getPhoneNumbers(
      {required String email}) async {
    try {
      final result = await remoteDataSource.getPhoneNumbers(email: email);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, DioResponse>> sendmessage({
    required PlatformFile excelFile,
    required List<ImageData> listImages,
    required String email,
    required String noWA,
    required String message,
    required String countryCode,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        email: email,
        noWA: noWA,
        message: message,
        excelFile: excelFile,
        listImages: listImages,
        countryCode: countryCode,
      );
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
