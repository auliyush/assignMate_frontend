import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/login_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/user_api_service.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../BaseScreens/login_Screen.dart';
import '../Screens/bottom_navigation.dart';
import '../admin/admin_bottom_navigation.dart';
class BaseApiService {

  final loginUrl = '${MyApp.mainUrl}/assignMate/app/login';
  final signUpUrl = '${MyApp.mainUrl}/assignMate/app/signUp';

  Future<LoginResponse?> loginApi(String phoneNumber, String password,
      BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
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
        // convert response jsondata
        final jsonData = jsonDecode(response.body);
        // convert jsondata into apiResponse
        final apiResponseData = ApiResponse.fromJson(jsonData);
        Navigator.of(context).pop();
        // validation
        if (apiResponseData.data == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponseData.errorMessage ?? 'An error occurred')),
            );
          }
          return null;
        } else {
          // convert apiResponse data into loginResponse data
          final loginResponse = LoginResponse.fromJson(apiResponseData.data);
          // set provider of login details
          Provider.of<LoginProvider>(context, listen: false)
              .updateLoginResponse(loginResponse);
          print('Login Id - ${loginResponse.loginId}');
          // todo remove navigator in every api their only work to return response
          // call api for getting user
          UserApiService userApiService = UserApiService();
          await userApiService.getUserByIdApi(loginResponse.loginId, context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Successful')));
          if(loginResponse.userRole == "admin"){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => const AdminBottomNavigation()),
                  (Route<dynamic> route) => false,);
          }else{
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => const BottomNavigation()),
                  (Route<dynamic> route) => false,);
          }
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
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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