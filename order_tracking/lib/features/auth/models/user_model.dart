class UserModel {
  final String userName;
  final String email;
  final String userId;

  UserModel({
    required this.userName,
    required this.email,
    required this.userId,
  });

  factory UserModel.fromeJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json["userName"]??"",
      email: json["email"]??"",
      userId: json["uid"]??"",
    );
  }

  Map<String, dynamic> toJson() => {
    "userName":userName,
    "email":email,
    "uid":userId
  };
}
