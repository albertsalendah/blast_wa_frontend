// Example of entity class
// example name user, product, order, etc.
class User {
  final String id;
  final String name;
  final String email;
  final String? refreshToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.refreshToken,
  });
}
