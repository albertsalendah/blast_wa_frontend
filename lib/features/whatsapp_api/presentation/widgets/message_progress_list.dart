import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/features/whatsapp_api/domain/entities/message_progress.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/bloc/websocket_cubit.dart';
import 'package:whatsapp_blast/features/whatsapp_api/presentation/widgets/message_progress_card.dart';

class MessageProgressList extends StatelessWidget {
  const MessageProgressList({super.key});

  @override
  Widget build(BuildContext context) {
    return _joinAllProgress();
  }

  Widget _joinAllProgress() {
    return BlocBuilder<WebSocketCubit, WebSocketState>(
      builder: (context, state) {
        // Step 1: Group messages by "sender"
        Map<String, Map<String, List<MessageProgress>>> groupedBySender = {};
        for (var message in state.messageProgress) {
          if (!groupedBySender.containsKey(message.sender)) {
            groupedBySender[message.sender] = {};
          }
          if (!groupedBySender[message.sender]!.containsKey(message.id)) {
            groupedBySender[message.sender]![message.id] = [];
          }
          groupedBySender[message.sender]![message.id]!.add(message);
        }

        // Step 2: Convert the grouped data into a list for ListView
        List<MapEntry<String, Map<String, List<MessageProgress>>>>
            groupedSendersList = groupedBySender.entries.toList();

        // Step 3: Filter out cancelled items
        for (var senderEntry in groupedSendersList) {
          senderEntry.value.removeWhere((groupId, messages) {
            return messages.any((message) => message.isCancel);
          });
        }

        // Step 4: Remove empty sender entries
        groupedSendersList
            .removeWhere((senderEntry) => senderEntry.value.isEmpty);

        return ListView.builder(
          itemCount: groupedSendersList.length,
          itemBuilder: (context, senderIndex) {
            String sender = groupedSendersList[senderIndex].key;
            Map<String, List<MessageProgress>> messagesById =
                groupedSendersList[senderIndex].value;

            if (messagesById.isEmpty) return SizedBox();
            // Render a sender's section
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress For : +$sender',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: AppPallete.borderColor,
                  ),
                ),
                ...messagesById.entries.map((entry) {
                  String groupId = entry.key;
                  List<MessageProgress> groupedMessages = entry.value;
                  final currentItem = groupedMessages.lastWhere(
                    (element) {
                      return (element.status == 'sending' ||
                          element.status == 'queued');
                    },
                    orElse: () => entry.value.last,
                  );
                  //processing
                  int processedCount = groupedMessages
                      .where((msg) => msg.status == 'sending')
                      .length;
                  int diffence = (currentItem.progressCount) - processedCount;
                  double progress = currentItem.totalData > 0
                      ? ((processedCount + diffence)) / currentItem.totalData
                      : 0;
                  return Dismissible(
                    key: ValueKey(groupId),
                    direction:
                        DismissDirection.endToStart, // Swipe left to remove
                    confirmDismiss: (direction) async {
                      if (progress != 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor: AppPallete.error,
                              content: Text(
                                'Cannot dismiss. Progress must be complete!',
                                style: TextStyle(color: AppPallete.white),
                              )),
                        );
                        return false;
                      }
                      return true;
                    },
                    onDismissed: (direction) {
                      context.read<WebSocketCubit>().removeCompleteMessage(
                            clientId: sender,
                            messageID: groupId,
                          );
                    },
                    background: Container(
                      color: AppPallete.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Icon(Icons.delete, color: AppPallete.white),
                    ),
                    child: MessageProgressCard(
                        groupId: groupId,
                        currentItem: currentItem,
                        processedCount: processedCount,
                        diffence: diffence,
                        progress: progress,
                        sender: sender),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    color: AppPallete.borderColor,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
