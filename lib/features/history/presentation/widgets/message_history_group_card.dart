import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history_group.dart';
import 'package:whatsapp_blast/features/history/presentation/bloc/message_history_bloc.dart';
import '../../../../config/theme/app_pallet.dart';

class MessageHistoryGroupCard extends StatelessWidget {
  final GlobalKey btnKey;
  final MessageHistoryGroup item;
  final double indeX100;
  const MessageHistoryGroupCard({
    super.key,
    required this.btnKey,
    required this.item,
    required this.indeX100,
  });

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox;
    Offset offset;
    return Stack(
      children: [
        Card(
          color: AppPallete.white,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✉️ ${item.message}',
                    maxLines: 1,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '📅 ${item.createAt}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '✉️ Total : ${item.successCount + item.failedCount}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '✅ Send : ${item.successCount}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.green),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '❌ Failed : ${item.failedCount}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.error),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: MenuAnchor(
                builder: (context, controller, child) {
                  return IconButton(
                    key: btnKey,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(CircleBorder()),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                          WidgetStateProperty.all(AppPallete.white),
                    ),
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: Icon(Icons.info_outline_rounded),
                  );
                },
                menuChildren: [
                  MenuItemButton(
                    onPressed: () {
                      if (btnKey.currentContext != null) {
                        if (btnKey.currentContext != null) {
                          renderBox = btnKey.currentContext!.findRenderObject()
                              as RenderBox;
                          offset = renderBox.localToGlobal(Offset.zero);
                          _show(
                              context: context,
                              renderBox: renderBox,
                              offset: offset);
                        }
                      }
                    },
                    child: Text('Detail'),
                  ),
                  MenuItemButton(
                    onPressed: () {
                      _showDeleteDialog(context: context, item: item);
                    },
                    child: Text('Delete'),
                  ),
                ])),
      ],
    );
  }

  _showDeleteDialog(
      {required BuildContext context, required MessageHistoryGroup item}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Delete This Message?')),
          titlePadding: EdgeInsets.only(top: 4),
          titleTextStyle: TextStyle(
              color: AppPallete.backgroundColor,
              fontSize: 20,
              fontWeight: FontWeight.w600),
          backgroundColor: AppPallete.white,
          contentPadding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          actionsPadding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
          actions: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<MessageHistoryBloc>().add(
                          DeleteMessageHistoryEvent(messageID: item.messageID));
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Delete'),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(AppPallete.error)),
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
          content: SizedBox(
            height: 400,
            width: 300,
            child: _popupContent(
              testStyle: TextStyle(color: AppPallete.backgroundColor),
            ),
          ),
        );
      },
    );
  }

  _show(
      {required BuildContext context,
      required RenderBox renderBox,
      required Offset offset}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                double topPosition =
                    item.imageUrl.isNotEmpty ? offset.dy - indeX100 : offset.dy;
                double rightPosition = constraints.maxWidth - offset.dx - 10;
                return Stack(
                  children: [
                    Positioned(
                      top: topPosition,
                      right: rightPosition - 10,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 300,
                          decoration: BoxDecoration(
                            color: AppPallete.darkGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _popupContent(
                              testStyle: TextStyle(color: AppPallete.white)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  SingleChildScrollView _popupContent({required TextStyle testStyle}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.imageUrl.isNotEmpty)
            Container(
              height: 285,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppPallete.backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: (item.imageUrl.length > 1)
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: item.imageUrl.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: imagesView(
                            imageUrl: item.imageUrl[index],
                          ),
                        );
                      },
                    )
                  : imagesView(imageUrl: item.imageUrl.first),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID : ${item.messageID}',
                  maxLines: 1,
                  style: testStyle,
                ),
              ],
            ),
          ),
          ExpandableText(
            'Message : ${item.message}',
            expandText: 'show more',
            collapseText: 'show less',
            maxLines: 5,
            style: testStyle,
            linkColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget imagesView({required String imageUrl, double? height}) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              "${dotenv.env['API_URL']}/$imageUrl",
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox.shrink();
              },
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
