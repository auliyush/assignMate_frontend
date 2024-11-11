import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/user_assigned_lists.dart';
import 'package:assign_mate/DataClasses/user_response.dart';
import 'package:assign_mate/Providers/user_provider.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserApiService {

  final String getUserByIdUrl = '${MyApp.mainUrl}/assignMate/user/get/By/Id';
  final String getStudentsList = '${MyApp.mainUrl}/assignMate/user/get/all/by/role';

  Future<UserResponse?> getUserByIdApi(String userId,
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
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID is missing')),
        );
        return null;
      }
      final url = Uri.parse(getUserByIdUrl).replace(
        queryParameters: {
          'userId': userId,
        },
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);

        if (apiResponse.data == null) {
          final errorMessage = apiResponse.errorMessage ?? 'An error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } else {
          final userResponse = UserResponse.fromJson(apiResponse.data);
          Provider.of<UserProvider>(context, listen: false).updateUserResponse(userResponse);
          print('User name - ${userResponse.userName}');
          return userResponse;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed with status: ${response.statusCode}')),
        );
      }
    }on http.ClientException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Server issue try again after some time')));
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
    return null;
  }

  Future<UserAssignmentList?> getAssignedAssignmentApi(String userId,
      BuildContext context) async {
    try{
      final url = Uri.parse(getUserByIdUrl).replace(
        queryParameters: {
          'userId': userId,
        },
      );
      final response = await http.get(url);
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          final errorMessage = apiResponse.errorMessage ?? 'An error occurred';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }else{
          final assignmentList = UserAssignmentList.fromJson(apiResponse.data);
          return assignmentList;
        }
      }
    } on http.ClientException catch (e){
      print(e);
    }
    return null;
  }

  Future<List<UserResponse>?> getListOfStudentsApi(BuildContext context) async {
    try{
      final url = Uri.parse(getStudentsList).replace(
        queryParameters: {
          "role" : "student",
        });
      final response = await http.get(url);

      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
        }else{
          final listOfStudents = (apiResponse.data as List<dynamic>)
              .map((e) => UserResponse.fromJson(e))
              .toList();
          print('Data fetched');
          return listOfStudents;
        }
      }else{
        print(response.statusCode);
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('server issue')));
    }
    return null;
  }
}