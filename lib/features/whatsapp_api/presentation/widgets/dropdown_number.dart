import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:whatsapp_blast/core/di/init_dependencies.dart';
import 'package:whatsapp_blast/core/network/token_manager.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/websocket_cubit.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/whatsapp_bloc.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/colored_dot.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/disconnect_button.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/progress_button.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/qr_button.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/qr_page.dart';

import '../../../../config/theme/app_pallet.dart';

class DropdownNumber extends StatefulWidget {
  final VoidCallback onTapProgress;
  const DropdownNumber({
    super.key,
    required this.onTapProgress,
  });

  @override
  State<DropdownNumber> createState() => _DropdownNumberState();
}

class _DropdownNumberState extends State<DropdownNumber> {
  List<String> listNumber = [];
  String email = '';
  String selectedClient = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = serviceLocator<TokenManager>().accessToken;
      email = token != null ? JwtDecoder.decode(token)['email'] : '';
      if (email.isNotEmpty) {
        context
            .read<WhatsappBloc>()
            .add(GetUserPhoneNumbersEvent(email: email));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WhatsappBloc, WhatsappState>(
      listener: (context, state) {
        if (state is GetPhoneSuccess) {
          listNumber = state.listNumbers.map((e) => e.whatsappNumber).toList();
          setState(() {});
          // if (listNumber.isNotEmpty && selectedClient.isEmpty) {
          //   context
          //       .read<WebSocketCubit>()
          //       .connectClient(clientId: listNumber.first);
          // }
        }
      },
      child: BlocConsumer<WebSocketCubit, WebSocketState>(
        listener: (context, state) {
          if (state.connectionStatus[state.selectedClient] ==
                  ConnectionStatus.open &&
              email.isNotEmpty) {
            // context
            //     .read<WhatsappBloc>()
            //     .add(GetUserPhoneNumbersEvent(email: email));
          }
        },
        builder: (context, state) {
          List<String> connectedClients = state.connectedClients;
          final hasActiveClients = connectedClients.isNotEmpty;
          selectedClient = hasActiveClients
              ? (connectedClients.contains(state.selectedClient)
                  ? state.selectedClient
                  : connectedClients.first)
              : listNumber.isNotEmpty
                  ? listNumber.first
                  : '';
          return SizedBox(
            height: 45,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QrButton(
                    visibility: connectedClients.contains('temp'),
                    onTap: () {
                      if (!connectedClients.contains('temp')) {
                        context
                            .read<WebSocketCubit>()
                            .connectClient(clientId: 'temp');
                      }
                      QrPage().show(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 180,
                    height: 32,
                    decoration: BoxDecoration(
                        color: AppPallete.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: listNumber.contains(selectedClient)
                            ? selectedClient
                            : listNumber.isNotEmpty
                                ? listNumber.first
                                : null,
                        isExpanded: true,
                        items: listNumber.map((clientId) {
                          return DropdownMenuItem(
                            value: clientId,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 22,
                                    child: Text(
                                      ' +$clientId',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                ColoredDot(
                                    isConnected:
                                        state.connectionStatus[clientId] ??
                                            ConnectionStatus.close),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            if (connectedClients.isEmpty ||
                                !connectedClients.contains(value)) {
                              context
                                  .read<WebSocketCubit>()
                                  .connectClient(clientId: value);
                            } else {
                              context
                                  .read<WebSocketCubit>()
                                  .selectClient(clientId: value);
                            }

                            if (state.connectionStatus[value] ==
                                    ConnectionStatus.connecting ||
                                state.connectionStatus[value] ==
                                    ConnectionStatus.close) {
                              QrPage().show(context);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ProgressButton(
                      messageProgress: state.messageProgress,
                      onTapProgress: widget.onTapProgress),
                  // const SizedBox(width: 8),
                  DisconnectButton(
                    visibility: connectedClients.isNotEmpty,
                    numConnected: connectedClients.length,
                    onTap: () {
                      if (selectedClient.isNotEmpty &&
                          connectedClients.isNotEmpty) {
                        context
                            .read<WebSocketCubit>()
                            .disconnectClient(clientId: selectedClient);
                      } else {
                        context
                            .read<WebSocketCubit>()
                            .disconnectClient(clientId: 'temp');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
