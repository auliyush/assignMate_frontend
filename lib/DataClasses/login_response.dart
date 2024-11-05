class LoginResponse{
  final String loginId;
  final String userRole;

  LoginResponse({required this.loginId, required this.userRole});

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
        loginId : json["loggedId"],
        userRole : json["loggedRole"],
    );
  }
}