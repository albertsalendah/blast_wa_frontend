part of 'whatsapp_bloc.dart';

@immutable
sealed class WhatsappState {
  const WhatsappState();
}

final class WhatsappInitial extends WhatsappState {}

final class WhatsappLoading extends WhatsappState {}

final class SendMessageSuccess extends WhatsappState {
  final DioResponse response;
  const SendMessageSuccess({required this.response});
}

final class GetPhoneSuccess extends WhatsappState {
  final List<PhoneNumber> listNumbers;
  const GetPhoneSuccess({required this.listNumbers});
}

final class WhatsappFailure extends WhatsappState {
  final String message;
  const WhatsappFailure([this.message = 'An unexpected error occured']);
}
