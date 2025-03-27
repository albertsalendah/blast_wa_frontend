part of 'whatsapp_bloc.dart';

@immutable
sealed class WhatsappEvent {}

final class GetUserPhoneNumbersEvent extends WhatsappEvent {
  final String email;
  GetUserPhoneNumbersEvent({required this.email});
}

final class SendMessageEvent extends WhatsappEvent {
  final MessegeParam messegeParam;
  SendMessageEvent({required this.messegeParam});
}

final class ConnectClientEvent extends WhatsappEvent {
  final String clientId;
  ConnectClientEvent({required this.clientId});
}

final class SelectClientEvent extends WhatsappEvent {
  final String clientId;
  SelectClientEvent({required this.clientId});
}

final class DisconnectClientEvent extends WhatsappEvent {
  final String clientId;
  DisconnectClientEvent({required this.clientId});
}
