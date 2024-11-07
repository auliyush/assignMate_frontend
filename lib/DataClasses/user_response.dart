class UserResponse{
  String userId;
  String userName;
  String phoneNumber;

  UserResponse({
    required this.userName,
    required this.phoneNumber,
    required this.userId,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json){
    return UserResponse(
      userName : json['userName'],
      phoneNumber: json['phoneNumber'],
      userId: json['userId'],
    );
  }
}