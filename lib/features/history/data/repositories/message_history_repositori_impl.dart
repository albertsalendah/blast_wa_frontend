import 'package:fpdart/fpdart.dart';
import 'package:whatsapp_blast/core/errors/exceptions.dart';

import 'package:whatsapp_blast/core/errors/failure.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/features/history/data/datasources/message_history_remote_data_source.dart';
import 'package:whatsapp_blast/features/history/data/models/message_history_group_model.dart';
import 'package:whatsapp_blast/features/history/data/models/message_history_model.dart';
import 'package:whatsapp_blast/features/history/domain/repositories/message_history_repository.dart';

class MessageHistoryRepositoriImpl implements MessageHistoryRepository {
  final MessageHistoryRemoteDataSource remoteDataSource;
  MessageHistoryRepositoriImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, List<MessageHistoryModel>>> getMessageHistory(
      {required String messageID}) async {
    try {
      final result =
          await remoteDataSource.getMessageHistory(messageID: messageID);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageHistoryGroupModel>>>
      getMessageHistoryGroup({required String email}) async {
    try {
      final result =
          await remoteDataSource.getMessageHistoryGroup(email: email);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, DioResponse>> deleteMessageHistory(
      {required String messageID}) async {
    try {
      final result =
          await remoteDataSource.deleteMessageHistory(messageID: messageID);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
