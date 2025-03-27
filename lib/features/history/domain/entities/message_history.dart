class MessageHistory {
  final int id;
  final String messageID;
  final String email;
  final String sender;
  final int totalData;
  final String targetName;
  final String targetNumber;
  final bool onWA;
  final String message;
  final bool messageStatus;
  final List<String> imageUrl;
  final String createAt;
  MessageHistory({
    required this.id,
    required this.messageID,
    required this.email,
    required this.sender,
    required this.totalData,
    required this.targetName,
    required this.targetNumber,
    required this.onWA,
    required this.message,
    required this.messageStatus,
    required this.imageUrl,
    required this.createAt,
  });
}
