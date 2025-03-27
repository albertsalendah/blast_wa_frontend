import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/message_progress.dart';

import '../../data/datasources/web_socket_remote_data_source.dart';

class WebSocketState {
  final List<String> connectedClients;
  final String selectedClient;
  List<MessageProgress> messageProgress;
  final Map<String, ConnectionStatus> connectionStatus;
  final Map<String, String> qrData;

  WebSocketState(
      {required this.connectedClients,
      required this.selectedClient,
      required this.messageProgress,
      required this.qrData,
      required this.connectionStatus});
}

class WebSocketCubit extends Cubit<WebSocketState> {
  final WebSocketRemoteDataSource repository;

  WebSocketCubit({required this.repository})
      : super(WebSocketState(
          connectedClients: [],
          selectedClient: '',
          messageProgress: [],
          qrData: {},
          connectionStatus: {},
        )) {
    repository.setCubit(cubit: this);
  }

  void connectClient({required String clientId}) {
    repository.connectClient(clientId: clientId);
    updateState(clientId: clientId);
  }

  void disconnectClient({required String clientId}) {
    repository.disconnectClient(clientId: clientId);
    updateState(clientId: clientId);
  }

  void selectClient({required String clientId}) {
    updateState(clientId: clientId);
  }

  void cancelMessage({required String clientId, required String messageID}) {
    repository.cancelMessage(clientId: clientId, messageID: messageID);
  }

  void pauseMessage({required String clientId, required String messageID}) {
    repository.pauseMessage(clientId: clientId, messageID: messageID);
  }

  void resumeMessage({required String clientId, required String messageID}) {
    repository.resumeMessage(clientId: clientId, messageID: messageID);
  }

  void removeCompleteMessage(
      {required String clientId, required String messageID}) {
    repository.removeCompleteMessage(clientId: clientId, messageID: messageID);
    updateState(clientId: clientId);
  }

  void updateState({String? clientId}) {
    emit(WebSocketState(
      connectedClients: repository.connectedClients.keys.toList(),
      selectedClient: clientId ?? state.selectedClient,
      messageProgress: repository.getMessageProgess(
          clientId: clientId ?? state.selectedClient),
      qrData: repository.qrData,
      connectionStatus: repository.connectionStatus,
    ));
  }
}
