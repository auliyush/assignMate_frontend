import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/user_response.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserApiService {

  final String getUserByIdUrl = '${MyApp
      .mainUrl}assignMate/userMethod/get/By/Id';

  Future<UserResponse?> getUserByIdApi(String userId,
      BuildContext context) async {
    try {
      final url = Uri.parse(getUserByIdUrl).replace(
          queryParameters: {
            'userId': userId,
          });
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if (apiResponse.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
        } else {
          final userResponse = UserResponse.fromJson(apiResponse.data);
          print('user name - ${userResponse.userName}');
          return userResponse;
        }
      }
    } on http.ClientException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Server issue try again after some time')));
    }
    return null;
  }
}