import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/usecase/usecase.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history.dart';
import 'package:whatsapp_blast/features/history/domain/repositories/message_history_repository.dart';

class GetMessageHistory implements UseCase<List<MessageHistory>, String> {
  final MessageHistoryRepository repository;
  GetMessageHistory({
    required this.repository,
  });
  @override
  Future<Either<Failure, List<MessageHistory>>> call(String params) async {
    return await repository.getMessageHistory(messageID: params);
  }
}
