// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:whatsapp_blast/core/errors/exceptions.dart';
import 'package:whatsapp_blast/core/shared/models/dio_response_model.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';

import 'package:whatsapp_blast/features/history/data/models/message_history_group_model.dart';
import 'package:whatsapp_blast/features/history/data/models/message_history_model.dart';

abstract interface class MessageHistoryRemoteDataSource {
  Future<List<MessageHistoryGroupModel>> getMessageHistoryGroup(
      {required String email});
  Future<List<MessageHistoryModel>> getMessageHistory(
      {required String messageID});
  Future<DioResponseModel> deleteMessageHistory({required String messageID});
}

class MessageHistoryRemoteDataSourceImpl
    implements MessageHistoryRemoteDataSource {
  final Dio client;
  MessageHistoryRemoteDataSourceImpl({
    required this.client,
  });

  DioResponseModel _handleDioException(DioException e) {
    if (e.response != null) {
      try {
        return DioResponseModel.fromJson(e.response!.data);
      } catch (error) {
        throw ServerException("Invalid response data: $error");
      }
    } else {
      throw ServerException(e.message ?? "Network error.");
    }
  }

  @override
  Future<List<MessageHistoryModel>> getMessageHistory(
      {required String messageID}) async {
    try {
      final response = await client
          .get(getMessageHistoryPath, data: {'messageID': messageID});
      if (response.data['list'] != null) {
        List<MessageHistoryModel> list = (response.data['list'] as List)
            .map((e) => MessageHistoryModel.fromJson(e))
            .toList();
        return list;
      } else {
        throw const ServerException('Data is null!');
      }
    } on DioException catch (_) {
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageHistoryGroupModel>> getMessageHistoryGroup(
      {required String email}) async {
    try {
      final response =
          await client.get(getMessageHistoryGroupPath, data: {'email': email});
      if (response.data['messageGroup'] != null) {
        List<MessageHistoryGroupModel> list =
            (response.data['messageGroup'] as List)
                .map((e) => MessageHistoryGroupModel.fromJson(e))
                .toList();
        return list;
      } else {
        throw const ServerException('Data is null!');
      }
    } on DioException catch (_) {
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DioResponseModel> deleteMessageHistory(
      {required String messageID}) async {
    try {
      final response = await client
          .post(deleteMessageHistoryPath, data: {'messageID': messageID});

      return response.data != null
          ? DioResponseModel.fromJson(response.data)
          : throw const ServerException('Data is null!');
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
