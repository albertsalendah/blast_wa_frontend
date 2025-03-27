part of 'message_history_bloc.dart';

@immutable
sealed class MessageHistoryEvent {}

final class GetMessageHistoryGroupEvent extends MessageHistoryEvent {
  final String email;
  GetMessageHistoryGroupEvent({required this.email});
}

final class GetMessageHistoryEvent extends MessageHistoryEvent {
  final String messageID;
  GetMessageHistoryEvent({
    required this.messageID,
  });
}

final class DeleteMessageHistoryEvent extends MessageHistoryEvent {
  final String messageID;
  DeleteMessageHistoryEvent({
    required this.messageID,
  });
}
