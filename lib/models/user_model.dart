class UserModel {
  final String uid;
  final String userName;
  final String email;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'userName': userName,
    'email': email,
  };

  // Create User object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String,
    userName: json['firstName'] as String,
    email: json['email'] as String,
  );
}
