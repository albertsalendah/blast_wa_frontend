import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import '../bloc/websocket_cubit.dart';

class QrPage {
  const QrPage();

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String qrData = '';
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: BlocConsumer<WebSocketCubit, WebSocketState>(
              listener: (context, state) {
            bool waConnectionStatus =
                state.connectionStatus[state.selectedClient] ==
                    ConnectionStatus.open;
            if (waConnectionStatus && Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          }, builder: (context, state) {
            qrData = state.qrData[state.selectedClient] ?? '';

            return SizedBox(
              width: 350,
              height: 380,
              child: Column(
                children: [
                  Text(
                    qrData.isNotEmpty
                        ? 'Please Scan QR Code'
                        : 'Please wait...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 335,
                    child: Visibility(
                      visible: qrData.isNotEmpty,
                      replacement: Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 320,
                        errorStateBuilder: (context, error) {
                          return Text('$error');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
