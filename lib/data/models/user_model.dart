import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required String id, required String email}) : super(id: id, email: email);

  factory UserModel.fromFirebase(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email']);
  }
}