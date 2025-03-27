import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/usecase/usecase.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history_group.dart';
import 'package:whatsapp_blast/features/history/domain/repositories/message_history_repository.dart';

class GetMessageHistoryGroup
    implements UseCase<List<MessageHistoryGroup>, String> {
  final MessageHistoryRepository repository;
  GetMessageHistoryGroup({
    required this.repository,
  });
  @override
  Future<Either<Failure, List<MessageHistoryGroup>>> call(String params) async {
    return await repository.getMessageHistoryGroup(email: params);
  }
}
