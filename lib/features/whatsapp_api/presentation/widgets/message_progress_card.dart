import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/core/utils/constants/constants.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/message_progress.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/websocket_cubit.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/play_pause_progress.dart';

class MessageProgressCard extends StatelessWidget {
  const MessageProgressCard({
    super.key,
    required this.groupId,
    required this.currentItem,
    required this.processedCount,
    required this.diffence,
    required this.progress,
    required this.sender,
  });

  final String groupId;
  final MessageProgress currentItem;
  final int processedCount;
  final int diffence;
  final double progress;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketCubit, WebSocketState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppPallete.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(100),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID : $groupId',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (currentItem.status == 'queued') ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '📌 Waiting in Queue',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    LinearProgressIndicator(backgroundColor: AppPallete.grey),
                  ] else ...[
                    Text(
                      'Name : ${currentItem.targetName ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Number : ${currentItem.targetNumber ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (currentItem.messageStatus != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              currentItem.messageStatus!
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.cancel_outlined,
                              color: currentItem.messageStatus!
                                  ? AppPallete.green
                                  : AppPallete.error,
                            ),
                          )
                      ],
                    ),
                    Text(
                      'Total Messages Sent: ${processedCount + diffence} / ${currentItem.totalData}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                              value: progress, color: AppPallete.green),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              if (state.connectionStatus[state.selectedClient] ==
                  ConnectionStatus.open)
                if (currentItem.status == 'sending' && progress != 1)
                  Positioned(
                    top: 1,
                    right: 1,
                    child: PlayPauseProgress(
                      currentItem: currentItem,
                      progress: progress,
                      sender: sender,
                      groupId: groupId,
                      onCancel: () {},
                    ),
                  ),
              if (progress == 1)
                Positioned(
                  top: 1,
                  right: 1,
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: AppPallete.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(100),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: IconButton(
                      color: AppPallete.error,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(CircleBorder()),
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        context.read<WebSocketCubit>().removeCompleteMessage(
                              clientId: sender,
                              messageID: groupId,
                            );
                      },
                      icon: Icon(Icons.cancel),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
