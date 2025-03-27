import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history_group.dart';

abstract interface class MessageHistoryRepository {
  Future<Either<Failure, List<MessageHistory>>> getMessageHistory(
      {required String messageID});
  Future<Either<Failure, List<MessageHistoryGroup>>> getMessageHistoryGroup(
      {required String email});
  Future<Either<Failure, DioResponse>> deleteMessageHistory(
      {required String messageID});
}
