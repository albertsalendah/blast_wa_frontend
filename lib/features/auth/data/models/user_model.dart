import '../../domain/entities/user.dart';

// this class has to extends a class from folder entities inside domain folder
// Example ExampleModel extends Example {}

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      refreshToken: json['refreshToken']?.toString(),
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
