// ignore_for_file: public_member_api_docs, sort_constructors_first
class MessageProgress {
  final String id;
  final String sender;
  int totalData = 0;
  final String? targetName;
  final String? targetNumber;
  final String? message;
  bool? messageStatus = false;
  final String status;
  int progressCount = 0;
  bool isPause = false;
  bool isCancel;
  MessageProgress({
    required this.id,
    required this.sender,
    required this.totalData,
    this.targetName,
    this.targetNumber,
    this.message,
    this.messageStatus,
    required this.status,
    required this.progressCount,
    required this.isPause,
    required this.isCancel,
  });
}
