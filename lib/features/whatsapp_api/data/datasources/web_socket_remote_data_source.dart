import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';
import 'package:whatsapp_blast/core/shared/entities/image_data.dart';
import 'package:whatsapp_blast/core/shared/models/dio_response_model.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/message_progress.dart';
import '../../../../core/errors/exceptions.dart';
import '../../presentation/bloc/websocket_cubit.dart';
import '../models/phone_number_model.dart';

abstract interface class WebSocketRemoteDataSource {
  void connectClient({required String clientId});
  void disconnectClient({required String clientId});
  List<MessageProgress> getMessageProgess({required String clientId});
  Map<String, IOWebSocketChannel> get connectedClients;
  Map<String, String> get qrData;
  Map<String, ConnectionStatus> get connectionStatus;
  Future<List<PhoneNumberModel>> getPhoneNumbers({required String email});
  void setCubit({required WebSocketCubit cubit});
  Future<DioResponseModel> sendMessage({
    required PlatformFile excelFile,
    required List<ImageData> listImages,
    required String email,
    required String noWA,
    required String message,
    required String countryCode,
  });
  void resumeMessage({required String clientId, required String messageID});
  void pauseMessage({required String clientId, required String messageID});
  void cancelMessage({required String clientId, required String messageID});
  void removeCompleteMessage(
      {required String clientId, required String messageID});
}

class WebSocketRemoteDataSourceImpl implements WebSocketRemoteDataSource {
  final Map<String, IOWebSocketChannel> _clients = {};
  final Map<String, List<MessageProgress>> _messageProgress = {};
  final Map<String, Timer?> _reconnectTimers = {}; // 🔹 Handle auto-reconnect
  final Map<String, bool> _idAssigned = {}; // 🔹 Tracks if ID is already set
  final Map<String, String> _qrData = {};
  final Map<String, ConnectionStatus> _connectionStatus =
      {}; // 🔹 Track WhatsApp connection status

  WebSocketCubit? webSocketCubitInstance; // Add a reference to WebSocketCubit
  final Dio client;
  WebSocketRemoteDataSourceImpl({
    required this.client,
  });

  @override
  void setCubit({required WebSocketCubit cubit}) {
    webSocketCubitInstance = cubit;
  }

  void _notifyCubit({String? clientId}) {
    if (webSocketCubitInstance != null) {
      webSocketCubitInstance!.updateState(clientId: clientId);
    }
  }

  @override
  void connectClient({required String clientId}) {
    if (_clients.containsKey(clientId)) {
      log("🔹 Client $clientId is already connected.");
      return;
    }
    log('✅ Connecting: $clientId');
    _attemptConnection(clientId: clientId);
  }

  @override
  void disconnectClient({required String clientId}) {
    final channel = _clients[clientId];
    if (channel != null) {
      channel.sink
          .add(jsonEncode({"type": "disconnect", "clientId": clientId}));
      channel.sink.close(1000, 'I am Out');
      _clients.remove(clientId);
      _connectionStatus[clientId] = ConnectionStatus.close;
      log('❌ Disconnected: $clientId');
    }
  }

  @override
  List<MessageProgress> getMessageProgess({required String clientId}) {
    List<MessageProgress> all = [
      // MessageProgress(
      //     id: 'adsdasd',
      //     sender: '6282138345212',
      //     totalData: 10,
      //     status: 'sending',
      //     progressCount: 1,
      //     messageStatus: true,
      //     isPause: false,
      //     isCancel: false)
    ];
    _clients.forEach(
      (key, value) {
        if (_messageProgress[key] != null) {
          all.addAll(_messageProgress[key]!);
        }
      },
    );
    return all; //to show all message progress in one list
    // return _messageProgress[clientId] ??
    //     []; //to show only progress based on selected client id
  }

  @override
  void removeCompleteMessage(
      {required String clientId, required String messageID}) {
    if (_messageProgress[clientId] != null) {
      _messageProgress[clientId]?.removeWhere(
        (element) {
          return ((element.progressCount == element.totalData) ||
                  (element.progressCount != element.totalData)) &&
              element.id == messageID;
        },
      );
    }
  }

  @override
  Map<String, IOWebSocketChannel> get connectedClients => _clients;

  @override
  Map<String, String> get qrData => _qrData;

  @override
  Map<String, ConnectionStatus> get connectionStatus => _connectionStatus;

  @override
  Future<List<PhoneNumberModel>> getPhoneNumbers(
      {required String email}) async {
    try {
      final response =
          await client.get(getPhoneNumbersPath, data: {'email': email});
      if (response.data != null) {
        List<PhoneNumberModel> phoneNumbers =
            (response.data['phoneNumbers'] as List)
                .map((e) => PhoneNumberModel.fromJson(e))
                .toList();
        return phoneNumbers;
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
  Future<DioResponseModel> sendMessage({
    required PlatformFile excelFile,
    required List<ImageData> listImages,
    required String email,
    required String noWA,
    required String message,
    required String countryCode,
  }) async {
    try {
      FormData formData = FormData();
      // Add username as a field
      formData.fields.add(MapEntry("countryCode", countryCode));
      formData.fields.add(MapEntry("email", email));
      formData.fields.add(MapEntry("noWA", noWA));
      formData.fields.add(MapEntry("message", message));

      MultipartFile excelMultipart;
      if (kIsWeb) {
        excelMultipart = MultipartFile.fromBytes(
          excelFile.bytes!,
          filename: excelFile.name,
          contentType: MediaType("application",
              "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
        );
      } else {
        excelMultipart = await MultipartFile.fromFile(
          excelFile.path!,
          filename: excelFile.name,
          contentType: MediaType("application",
              "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
        );
      }
      formData.files.add(MapEntry("excelFile", excelMultipart));

      for (int i = 0; i < listImages.length; i++) {
        if (listImages[i].byte != null) {
          formData.files.add(MapEntry(
            "images",
            MultipartFile.fromBytes(listImages[i].byte!,
                filename: listImages[i].name,
                contentType: MediaType("image", "jpeg")),
          ));
        }
      }
      Response response = await client.post(sendMessagePath, data: formData);
      return response.data != null
          ? DioResponseModel.fromJson(response.data)
          : throw const ServerException('Sending message failed');
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

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
  void cancelMessage({required String clientId, required String messageID}) {
    final channel = _clients[clientId];
    if (channel != null) {
      channel.sink
          .add(jsonEncode({"type": "cancelMessage", "messageID": messageID}));
    }
  }

  @override
  void pauseMessage({required String clientId, required String messageID}) {
    final channel = _clients[clientId];
    if (channel != null) {
      channel.sink
          .add(jsonEncode({"type": "pauseMessage", "messageID": messageID}));
    }
  }

  @override
  void resumeMessage({required String clientId, required String messageID}) {
    final channel = _clients[clientId];
    if (channel != null) {
      channel.sink
          .add(jsonEncode({"type": "resumeMessage", "messageID": messageID}));
    }
  }

  void _attemptConnection({required String clientId}) {
    try {
      final channel = IOWebSocketChannel.connect(dotenv.env['WS_URL'] ?? '');
      _clients[clientId] = channel;
      _messageProgress[clientId] = [];
      _idAssigned[clientId] = false; // 🔹 Reset ID assignment on new connection
      _qrData[clientId] = '';
      _connectionStatus[clientId] = ConnectionStatus.close;

      String? token = serviceLocator<TokenManager>().accessToken;
      String email = token != null ? JwtDecoder.decode(token)['email'] : '';

      // 🔹 Send setId **only if not already assigned**
      Future.delayed(Duration(milliseconds: 500), () {
        if (!_idAssigned[clientId]! && email.isNotEmpty) {
          log('✅ Connecting: $clientId');
          channel.sink.add(jsonEncode({
            "type": "setId",
            "id": clientId,
            "email": email,
          }));
        }
      });
      _socketListner(channel, clientId, email);
      _notifyCubit();
      log('✅ Connected: $clientId');
      log('Total Connected Client : ${_clients.length} -> ${_clients.keys}');
    } catch (e) {
      log("❌ Connection failed for $clientId: $e");
      _handleDisconnection(clientId: clientId);
    }
  }

  void _handleDisconnection({required String clientId}) {
    try {
      _clients.remove(clientId);
      _connectionStatus[clientId] = ConnectionStatus.close;
      log("🔁 Attempting to reconnect $clientId in 5 seconds...");

      _reconnectTimers[clientId]?.cancel();
      _reconnectTimers[clientId] = Timer(Duration(seconds: 5), () {
        log("🔄 Reconnecting: $clientId");
        _attemptConnection(clientId: clientId);
      });
      _notifyCubit();
    } on WebSocketChannelException catch (e) {
      log("❌ WebSocketChannelException for $clientId: $e");
    } on SocketException catch (e) {
      log("❌ SocketException Network error for $clientId: $e");
    } catch (e) {
      log("❌ Connection failed for $clientId: $e");
    }
  }

  void _stopReconnection({required String clientId}) {
    _reconnectTimers[clientId]?.cancel();
    _reconnectTimers.remove(clientId);
  }

  StreamSubscription<dynamic> _socketListner(
      IOWebSocketChannel channel, String clientId, String email) {
    return channel.stream.listen(
      (event) {
        final data = jsonDecode(event);

        if (data['type'] == 'idSet' && data['id'] == clientId) {
          _idAssigned[clientId] = true; // 🔹 Mark as assigned
          if (email.isNotEmpty) {
            final msg = jsonEncode({
              "type": "connectWhatsApp",
              "clientId": clientId,
              "email": email,
            });
            channel.sink.add(msg);
          } else {
            log("⚠️ Cannot send request. Client $clientId is not connected.");
          }
          log("✅ Server confirmed ID assignment for $clientId");
        }

        if (data['type'] == 'qrCode') {
          _qrData[clientId] = data['qr'];
          _connectionStatus[data['accountId']] = ConnectionStatus.qr;
          log('✅ QR data received for ${data['accountId']}');
        }

        if (data['type'] == 'reconnect') {
          final oldId = data['oldId'];
          final newId = data['newId'];
          channel.sink
              .add(jsonEncode({"type": "disconnect", "clientId": oldId}));
          channel.sink.close(1000, 'I am Out');
          _idAssigned.remove(oldId);
          _clients.remove(oldId);
          _stopReconnection(clientId: oldId);
          _attemptConnection(clientId: newId);
          _notifyCubit(clientId: newId);
        }

        if (data['type'] == 'disconnect') {
          log('Client with Id : ${data['clientId']} has disconnect');
          _connectionStatus[clientId] = ConnectionStatus.close;
        }

        if (data['type'] == 'connectionStatus') {
          log('Client WhatsApp connection status is : ${data['status']} for account id : ${data['accountId']}');
          if (data['status'] == 'open') {
            _connectionStatus[data['accountId']] = ConnectionStatus.open;
            log('✅ Whatsapp connection open for ${data['accountId']}');
          } else if (data['status'] == 'close') {
            _connectionStatus[data['accountId']] = ConnectionStatus.close;
          } else {
            _connectionStatus[data['accountId']] = ConnectionStatus.connecting;
          }
        }

        if (data['type'] == 'queue_status') {
          // log('✅ $clientId Message With ID : ${data['id']} Is being : ${data['status']}');
          _messageProgress[clientId]?.add(MessageProgress(
            id: data['id'] ?? '',
            totalData: 0,
            sender: data['sender'],
            status: data['status'],
            progressCount: 0,
            isPause: false,
            isCancel: false,
          ));
        }

        if (data['type'] == 'message_progress') {
          _messageProgress[clientId]?.add(
            MessageProgress(
              id: data['id'],
              sender: data['sender'],
              totalData: data['totalData'],
              targetName: data['targetName'].toString(),
              targetNumber: data['targetNumber'].toString(),
              message: data['message'],
              messageStatus: data['messageStatus'],
              status: data['status'],
              progressCount: data['progressCount'],
              isPause: data['isPause'],
              isCancel: data['isCancel'],
            ),
          );
        }
        _notifyCubit();
      },
      onError: (error) {
        log("❌ WebSocket error for $clientId: $error");
        _handleDisconnection(clientId: clientId);
      },
      onDone: () {
        log("❌ Connection closed for $clientId");
        _connectionStatus[clientId] = ConnectionStatus.close;
      },
    );
  }
}
