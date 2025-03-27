import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history_group.dart';
import 'package:whatsapp_blast/features/history/domain/usecases/delete_message_history.dart';
import 'package:whatsapp_blast/features/history/domain/usecases/get_message_history.dart';
import 'package:whatsapp_blast/features/history/domain/usecases/get_message_history_group.dart';

part 'message_history_event.dart';
part 'message_history_state.dart';

class MessageHistoryBloc
    extends Bloc<MessageHistoryEvent, MessageHistoryState> {
  final GetMessageHistory _getMessageHistory;
  final GetMessageHistoryGroup _getMessageHistoryGroup;
  final DeleteMessageHistory _deleteMessageHistory;
  MessageHistoryBloc({
    required GetMessageHistory getMessageHistory,
    required GetMessageHistoryGroup getMessageHistoryGroup,
    required DeleteMessageHistory deleteMessageHistory,
  })  : _getMessageHistory = getMessageHistory,
        _getMessageHistoryGroup = getMessageHistoryGroup,
        _deleteMessageHistory = deleteMessageHistory,
        super(MessageHistoryInitial()) {
    on<MessageHistoryEvent>((event, emit) {
      emit(MessageHistoryLoading());
    });
    on<GetMessageHistoryGroupEvent>(_onGetMessageHistoryGroup);
    on<GetMessageHistoryEvent>(_onGetMessageHistory);
    on<DeleteMessageHistoryEvent>(_onDeleteMessageHistory);
  }

  void _onGetMessageHistoryGroup(GetMessageHistoryGroupEvent event,
      Emitter<MessageHistoryState> emit) async {
    await _getMessageHistoryGroup(event.email).then(
      (response) {
        response.fold(
          (failure) => emit(MessageHistoryFailure(failure.message)),
          (success) => emit(GetMessageHistoryGroupState(list: success)),
        );
      },
    );
  }

  void _onGetMessageHistory(
      GetMessageHistoryEvent event, Emitter<MessageHistoryState> emit) async {
    await _getMessageHistory(event.messageID).then(
      (response) {
        response.fold((failure) => emit(MessageHistoryFailure(failure.message)),
            (success) {
          emit(GetMessageHistoryState(
              messageID: event.messageID, list: success));
        });
      },
    );
  }

  void _onDeleteMessageHistory(DeleteMessageHistoryEvent event,
      Emitter<MessageHistoryState> emit) async {
    await _deleteMessageHistory(event.messageID).then(
      (response) {
        response.fold((failure) => emit(MessageHistoryFailure(failure.message)),
            (success) {
          emit(DeleteMessageHistoryState(response: success));
        });
      },
    );
  }
}
