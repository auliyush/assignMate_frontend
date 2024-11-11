import 'package:assign_mate/DataClasses/user_response.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  UserResponse? _userResponse;

  UserResponse? get userResponse => _userResponse;

  void updateUserResponse(UserResponse userResponse){
    _userResponse = userResponse;
    notifyListeners();
  }
}