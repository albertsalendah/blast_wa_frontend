import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/core/shared/entities/dio_response.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/usecases/get_user_phone_numbers.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/usecases/send_message.dart';

import '../../domain/entities/phone_number.dart';

part 'whatsapp_event.dart';
part 'whatsapp_state.dart';

class WhatsappBloc extends Bloc<WhatsappEvent, WhatsappState> {
  final GetUserPhoneNumbers _getUserPhoneNumbers;
  final SendMessage _sendMessage;
  WhatsappBloc({
    required GetUserPhoneNumbers getUserPhoneNumber,
    required SendMessage sendMessage,
  })  : _getUserPhoneNumbers = getUserPhoneNumber,
        _sendMessage = sendMessage,
        super(WhatsappInitial()) {
    on<WhatsappEvent>((event, emit) {
      emit(WhatsappLoading());
    });

    on<GetUserPhoneNumbersEvent>(_onGetUserPhone);
    on<SendMessageEvent>(_onSendMessage);
  }
  void _onGetUserPhone(
      GetUserPhoneNumbersEvent event, Emitter<WhatsappState> emit) async {
    await _getUserPhoneNumbers(event.email).then(
      (response) {
        response.fold(
          (failure) => emit(WhatsappFailure(failure.message)),
          (success) => emit(GetPhoneSuccess(listNumbers: success)),
        );
      },
    );
  }

  void _onSendMessage(
      SendMessageEvent event, Emitter<WhatsappState> emit) async {
    await _sendMessage(event.messegeParam).then(
      (response) {
        response.fold(
          (failure) => emit(WhatsappFailure(failure.message)),
          (success) => emit(SendMessageSuccess(response: success)),
        );
      },
    );
  }
}
