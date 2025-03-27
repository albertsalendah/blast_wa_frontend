import 'package:flutter/material.dart';
import 'package:whatsapp_blast/config/theme/app_pallet.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history.dart';

class MessageHistoryListCard extends StatelessWidget {
  final String messageID;
  final List<MessageHistory> messages;
  final Map<String, int> currentPageMap;
  final VoidCallback onPageChange;
  const MessageHistoryListCard({
    super.key,
    required this.messageID,
    required this.messages,
    required this.currentPageMap,
    required this.onPageChange,
  });

  TextStyle stl() {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  }

  @override
  Widget build(BuildContext context) {
    int pageSize = 10;
    int totalPages = (messages.length / pageSize).ceil();
    int currentPage = currentPageMap[messageID] ?? 1;
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = (startIndex + pageSize).clamp(0, messages.length);
    List<MessageHistory> paginatedMessages =
        messages.sublist(startIndex, endIndex);
    return Column(
      children: [
        ...(paginatedMessages.map((msg) => _card(msg))),
        if (messages.length > pageSize)
          _paginationControls(messageID, currentPage, totalPages),
      ],
    );
  }

  Widget _card(MessageHistory msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: AppPallete.white,
        child: ListTile(
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rows(label: 'Name', value: msg.targetName),
                _rows(label: 'Number', value: msg.targetNumber),
                Row(
                  children: [
                    SizedBox(width: 95, child: Text('On WA', style: stl())),
                    Icon(
                      msg.onWA ? Icons.check_circle : Icons.cancel,
                      color: msg.onWA ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 95, child: Text('Send')),
                    Icon(
                      msg.messageStatus ? Icons.check : Icons.close,
                      color: msg.messageStatus ? Colors.blue : Colors.red,
                      size: 20,
                    ),
                  ],
                ),
                _rows(label: 'Created At', value: msg.createAt),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _rows({required String label, required String value}) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: Text(
              label,
              style: stl(),
              maxLines: 1,
            )),
        Text(value, maxLines: 1, style: stl()),
      ],
    );
  }

  Widget _paginationControls(
      String messageID, int currentPage, int totalPages) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.first_page),
            onPressed: currentPage > 1 ? () => _changePage(messageID, 1) : null,
          ),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => _changePage(messageID, currentPage - 1)
                : null,
          ),
          Text("Page $currentPage of $totalPages"),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => _changePage(messageID, currentPage + 1)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.last_page),
            onPressed: currentPage < totalPages
                ? () => _changePage(messageID, totalPages)
                : null,
          ),
        ],
      ),
    );
  }

  /// Update page
  void _changePage(String messageID, int newPage) {
    currentPageMap[messageID] = newPage;
    onPageChange();
  }
}
