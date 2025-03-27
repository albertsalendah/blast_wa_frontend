import 'package:whatsapp_blast/core/utils/convert_date.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history_group.dart';

class MessageHistoryGroupModel extends MessageHistoryGroup {
  MessageHistoryGroupModel({
    required super.messageID,
    required super.sender,
    required super.message,
    required super.imageUrl,
    required super.createAt,
    required super.successCount,
    required super.failedCount,
  });

  factory MessageHistoryGroupModel.fromJson(Map<String, dynamic> json) {
    String dateTime = convertDateTime(json['createAt']);
    return MessageHistoryGroupModel(
      messageID: json['messageID'],
      sender: json['sender'],
      message: json['message'],
      imageUrl: List<String>.from(json['imageUrl']),
      createAt: dateTime,
      successCount: int.parse(json['successCount']),
      failedCount: int.parse(json['failedCount']),
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'sender': sender,
      'message': message,
      'imageUrl': imageUrl,
      'createAt': createAt,
      'successCount': successCount.toString(),
      'failedCount': failedCount.toString(),
    };
  }

  MessageHistoryGroupModel copyWith({
    String? messageID,
    String? sender,
    String? message,
    List<String>? imageUrl,
    String? createAt,
    int? successCount,
    int? failedCount,
  }) {
    return MessageHistoryGroupModel(
      messageID: messageID ?? this.messageID,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      createAt: createAt ?? this.createAt,
      successCount: successCount ?? this.successCount,
      failedCount: failedCount ?? this.failedCount,
    );
  }
}
