import 'package:flutter/material.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history.dart';

class MessageHistoryTable extends StatelessWidget {
  final ScrollController _scrollController;
  final List<MessageHistory> listMessage;
  final BoxConstraints constraints;
  const MessageHistoryTable({
    super.key,
    required this.constraints,
    required ScrollController scrollController,
    required this.listMessage,
  }) : _scrollController = scrollController;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: constraints.maxWidth < 1000 ? 1100 : constraints.maxWidth - 40,
          child: PaginatedDataTable(
            showFirstLastButtons: true,
            columns: const [
              DataColumn(label: Text('No'), numeric: true),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Number')),
              DataColumn(label: Text('On WA')),
              DataColumn(label: Text('Send')),
              DataColumn(label: Text('Created At')),
            ],
            source: MessageHistoryDataSource(listMessage),
            rowsPerPage: 10,
          ),
        ),
      ),
    );
  }
}

class MessageHistoryDataSource extends DataTableSource {
  final List<MessageHistory> messages;

  MessageHistoryDataSource(this.messages);

  @override
  DataRow? getRow(int index) {
    if (index >= messages.length) return null;
    final message = messages[index];

    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(
        message.targetName,
        maxLines: 1,
      )),
      DataCell(Text(message.targetNumber)),
      DataCell(Icon(
        message.onWA ? Icons.check_circle : Icons.cancel,
        color: message.onWA ? Colors.green : Colors.red,
      )),
      DataCell(Icon(
        message.messageStatus ? Icons.check : Icons.close,
        color: message.messageStatus ? Colors.blue : Colors.red,
      )),
      DataCell(Text(message.createAt)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => messages.length;

  @override
  int get selectedRowCount => 0;
}
