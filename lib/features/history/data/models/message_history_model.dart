import 'package:whatsapp_blast/core/utils/convert_date.dart';
import 'package:whatsapp_blast/features/history/domain/entities/message_history.dart';

class MessageHistoryModel extends MessageHistory {
  MessageHistoryModel({
    required super.id,
    required super.messageID,
    required super.email,
    required super.sender,
    required super.totalData,
    required super.targetName,
    required super.targetNumber,
    required super.onWA,
    required super.message,
    required super.messageStatus,
    required super.imageUrl,
    required super.createAt,
  });

  factory MessageHistoryModel.fromJson(Map<String, dynamic> json) {
    String dateTime = convertDateTime(json['createAt']);

    return MessageHistoryModel(
      id: json['id'],
      messageID: json['messageID'],
      email: json['email'],
      sender: json['sender'],
      totalData: json['totalData'],
      targetName: json['targetName'],
      targetNumber: json['targetNumber'],
      onWA: json['onWA'] == 1,
      message: json['message'],
      messageStatus: json['messageStatus'] == 1,
      imageUrl: List<String>.from(json['imageUrl']),
      createAt: dateTime,
    );
  }

  // Method to convert the object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageID': messageID,
      'email': email,
      'sender': sender,
      'totalData': totalData,
      'targetName': targetName,
      'targetNumber': targetNumber,
      'onWA': onWA ? 1 : 0, // Convert bool to 1/0
      'message': message,
      'messageStatus': messageStatus ? 1 : 0, // Convert bool to 1/0
      'imageUrl': imageUrl,
      'createAt': createAt,
    };
  }

  MessageHistoryModel copyWith({
    int? id,
    String? messageID,
    String? email,
    String? sender,
    int? totalData,
    String? targetName,
    String? targetNumber,
    bool? onWA,
    String? message,
    bool? messageStatus,
    List<String>? imageUrl,
    String? createAt,
  }) {
    return MessageHistoryModel(
      id: id ?? this.id,
      messageID: messageID ?? this.messageID,
      email: email ?? this.email,
      sender: sender ?? this.sender,
      totalData: totalData ?? this.totalData,
      targetName: targetName ?? this.targetName,
      targetNumber: targetNumber ?? this.targetNumber,
      onWA: onWA ?? this.onWA,
      message: message ?? this.message,
      messageStatus: messageStatus ?? this.messageStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      createAt: createAt ?? this.createAt,
    );
  }
}
