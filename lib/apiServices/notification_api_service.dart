import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/user_notification_list.dart';
import 'package:flutter/material.dart';

import '../DataClasses/notification_response.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class NotificationApiService{
  final String getUserByIdUrl = '${MyApp.mainUrl}/assignMate/user/get/By/Id';
  final String deleteNotificationUrl = '${MyApp.mainUrl}assignMate/notification/delete';

  Future<UserNotificationList?> getNotificationApi(String userId,
      BuildContext context) async{
    try{
      final url = Uri.parse(getUserByIdUrl).replace(queryParameters: {
        'userId' : userId
      });
      final response = await http.get(url);
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
        }else{
          final notificationList = UserNotificationList.fromJson(apiResponse.data);
          return notificationList;
        }
      }else{
        print(response.statusCode);
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server issue')));
    }
    return null;
  }

  // under process

  // Future<bool> deleteNotificationApi(String userId, String notificationId,
  //     BuildContext context) async {
  //   try{
  //     final uri = // todo backend maybe wrong check first
  //     // todo check also update api
  //   }on http.ClientException catch(e){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server issue')));
  //   }
  // }
}