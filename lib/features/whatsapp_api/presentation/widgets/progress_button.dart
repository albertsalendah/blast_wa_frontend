import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';

import '../../domain/entities/message_progress.dart';

class ProgressButton extends StatelessWidget {
  final List<MessageProgress> messageProgress;
  final VoidCallback onTapProgress;
  const ProgressButton({
    super.key,
    required this.messageProgress,
    required this.onTapProgress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Center(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 32,
                width: 32,
                child: IconButton(
                  hoverColor: AppPallete.borderColor.withAlpha(50),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(CircleBorder()),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.all(AppPallete.white),
                  ),
                  icon: Icon(
                    Icons.list,
                    color: AppPallete.green,
                  ),
                  onPressed: onTapProgress,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IgnorePointer(
                child: Container(
                  height: 16,
                  width: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppPallete.green,
                  ),
                  child: Text(
                    getTotalProgress(messageProgress: messageProgress)
                        .toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppPallete.white,
                        fontSize: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getTotalProgress({required List<MessageProgress> messageProgress}) {
    // Group messages by sender and ID
    Map<String, Map<String, List<MessageProgress>>> groupedBySender = {};
    for (var message in messageProgress) {
      groupedBySender
          .putIfAbsent(message.sender, () => {})
          .putIfAbsent(message.id, () => [])
          .add(message);
    }

    // Flatten grouped messages and calculate the total progress
    int totalLength = 0;
    groupedBySender.forEach((_, messagesById) {
      messagesById.forEach((_, groupedMessages) {
        final currentItem = groupedMessages.lastWhere(
          (element) =>
              (element.status == 'sending' || element.status == 'queued'),
          orElse: () => groupedMessages.last,
        );
        int processedCount =
            groupedMessages.where((msg) => msg.status == 'sending').length;
        int difference = currentItem.progressCount - processedCount;
        double progress = currentItem.totalData > 0
            ? (processedCount + difference) / currentItem.totalData
            : 0;

        // Only count items where progress is not complete
        if (progress < 1 && !currentItem.isCancel) {
          totalLength++;
        }
      });
    });

    return totalLength;
  }
}
