enum UserRole { performer, customer }

class User {
  final String id;
  final String email;
  final List<UserRole> roles;
  final UserRole activeRole;

  User({
    required this.id,
    required this.email,
    required this.roles,
    required this.activeRole,
  });
}
