import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/websocket_cubit.dart';

import '../../domain/entities/message_progress.dart';

class PlayPauseProgress extends StatelessWidget {
  final MessageProgress currentItem;
  final double progress;
  final String sender;
  final String groupId;
  final VoidCallback onCancel;
  const PlayPauseProgress({
    super.key,
    required this.currentItem,
    required this.sender,
    required this.groupId,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: AppPallete.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(100),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Wrap(
          spacing: 4,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: IconButton(
                color:
                    !currentItem.isPause ? AppPallete.grey : AppPallete.green,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(CircleBorder()),
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  setState(() {});

                  if (currentItem.isPause) {
                    context
                        .read<WebSocketCubit>()
                        .resumeMessage(clientId: sender, messageID: groupId);
                    currentItem.isPause = false;
                  } else {
                    context
                        .read<WebSocketCubit>()
                        .pauseMessage(clientId: sender, messageID: groupId);
                    currentItem.isPause = true;
                  }
                },
                icon: Icon(!currentItem.isPause
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded),
              ),
            ),
            Visibility(
              // visible: progress != 1,
              child: SizedBox(
                height: 24,
                width: 24,
                child: IconButton(
                  color: AppPallete.error,
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(CircleBorder()),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    context
                        .read<WebSocketCubit>()
                        .cancelMessage(clientId: sender, messageID: groupId);
                    onCancel();
                  },
                  icon: Icon(Icons.cancel),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
