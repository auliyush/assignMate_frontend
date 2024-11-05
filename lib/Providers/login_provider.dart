import 'package:assign_mate/DataClasses/login_response.dart';
import 'package:flutter/cupertino.dart';

class LoginProvider with ChangeNotifier{
  LoginResponse? _loginResponse;

  LoginResponse? get loginResponse => _loginResponse;

  void updateLoginResponse(LoginResponse response){
    _loginResponse = response;
    notifyListeners();
  }
}