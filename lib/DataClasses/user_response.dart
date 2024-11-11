class UserResponse{
  String userId;
  String userName;
  String phoneNumber;
  UserResponse({
    required this.userId,
    required this.userName,
    required this.phoneNumber,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json){
    return UserResponse(
      userId: json['userId'],
      userName : json['userName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
/*
    List<FetchedPlayerData> players = (jsonData['playerList'] as List<dynamic>).map((playerJson) => FetchedPlayerData.fromJson(playerJson)).toList().cast<FetchedPlayerData>();

 */