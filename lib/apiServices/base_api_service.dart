import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/login_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class BaseApiService {

  final loginUrl = '${MyApp.mainUrl}/assignMate/app/login';
  final signUpUrl = '${MyApp.mainUrl}/assignMate/app/signUp';

  Future<LoginResponse?> loginApi(String phoneNumber, String password,
      BuildContext context) async {
    try {
      final response = await http.post(Uri.parse(loginUrl),
          headers: {
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "phoneNumber": phoneNumber,
            "password": password,
          }));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final apiResponseData = ApiResponse.fromJson(jsonData);
        if (apiResponseData.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponseData.errorMessage)));
        } else {
          final loginResponse = LoginResponse.fromJson(apiResponseData.data);
          Provider.of<LoginProvider>(context, listen: false)
              .updateLoginResponse(loginResponse);
          print('Login Id - ${loginResponse.loginId}');
          return loginResponse;
        }
      }
    } on http.ClientException catch (e) {
      print('Login Screen - $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Issue')));
    }
    return null;
  }

  Future<bool> signUpApi(String userName, String phoneNumber, String password, String role,
      BuildContext context) async {
    try{
      final response = await http.post(Uri.parse(signUpUrl),
        headers: {
        'Content-Type' : 'application/json'
        },
        body: jsonEncode({
          'userName' : userName,
          'phoneNumber' : phoneNumber,
          'password' : password,
          'role' : role,
        }),
      );

      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created')));
          print('create account status - ${apiResponse.data}');
          return apiResponse.data;

        }
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Issue')));
    }
    return false;
  }
}