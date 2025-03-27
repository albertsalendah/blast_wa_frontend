part of 'message_history_bloc.dart';

@immutable
sealed class MessageHistoryState {
  const MessageHistoryState();
}

final class MessageHistoryInitial extends MessageHistoryState {}

final class MessageHistoryLoading extends MessageHistoryState {}

final class GetMessageHistoryGroupState extends MessageHistoryState {
  final List<MessageHistoryGroup> list;
  const GetMessageHistoryGroupState({required this.list});
}

final class GetMessageHistoryState extends MessageHistoryState {
  final String messageID;
  final List<MessageHistory> list;
  const GetMessageHistoryState({required this.messageID, required this.list});
}

final class MessageHistoryFailure extends MessageHistoryState {
  final String message;
  const MessageHistoryFailure([this.message = 'An unexpected error occured']);
}

final class DeleteMessageHistoryState extends MessageHistoryState {
  final DioResponse response;
  const DeleteMessageHistoryState({required this.response});
}
