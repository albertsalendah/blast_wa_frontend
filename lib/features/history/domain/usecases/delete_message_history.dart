import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/core/usecase/usecase.dart';
import 'package:whatsapp_blast/features/history/domain/repositories/message_history_repository.dart';

class DeleteMessageHistory implements UseCase<DioResponse, String> {
  final MessageHistoryRepository repository;
  DeleteMessageHistory({
    required this.repository,
  });
  @override
  Future<Either<Failure, DioResponse>> call(String params) async {
    return await repository.deleteMessageHistory(messageID: params);
  }
}
