// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/core/usecase/usecase.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/repositories/whatsapp_api_repository.dart';

class SendMessage implements UseCase<DioResponse, MessegeParam> {
  final WhatsappApiRepository repository;
  SendMessage({
    required this.repository,
  });
  @override
  Future<Either<Failure, DioResponse>> call(MessegeParam params) async {
    return await repository.sendmessage(
      excelFile: params.excelFile,
      listImages: params.listImages,
      email: params.email,
      noWA: params.noWA,
      message: params.message,
      countryCode: params.countryCode,
    );
  }
}

class MessegeParam {
  PlatformFile excelFile;
  List<ImageData> listImages;
  String email;
  String noWA;
  String message;
  String countryCode;
  MessegeParam({
    required this.excelFile,
    required this.listImages,
    required this.email,
    required this.noWA,
    required this.message,
    required this.countryCode,
  });
}
