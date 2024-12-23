import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required List<UserRole> roles,
    required UserRole activeRole,
  }) : super(
          id: id,
          email: email,
          roles: roles,
          activeRole: activeRole,
        );

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    final roles = List<String>.from(data['roles'] ?? []);
    final activeRole = data['activeRole'] == 'performer'
        ? UserRole.performer
        : UserRole.customer;

    return UserModel(
      id: id,
      email: data['email'] ?? '',
      roles: roles.map((role) => role == 'performer' ? UserRole.performer : UserRole.customer).toList(),
      activeRole: activeRole,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'roles': roles.map((role) => role == UserRole.performer ? 'performer' : 'customer').toList(),
      'activeRole': activeRole == UserRole.performer ? 'performer' : 'customer',
    };
  }
}
