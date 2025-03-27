// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageHistoryGroup {
  final String messageID;
  final String sender;
  final String message;
  final List<String> imageUrl;
  final String createAt;
  final int successCount;
  final int failedCount;
  MessageHistoryGroup({
    required this.messageID,
    required this.sender,
    required this.message,
    required this.imageUrl,
    required this.createAt,
    required this.successCount,
    required this.failedCount,
  });
}
