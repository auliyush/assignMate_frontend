import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/feedback_response.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackApiService{
  final String getFeedbackUrl = '${MyApp.mainUrl}/assignMate/feedback/get/by/submissionId';
  final String createFeedbackUrl = '${MyApp.mainUrl}/assignMate/feedback/create';

  Future<bool> createFeedbackApi(String adminId, String submissionId,
      String feedback, DateTime feedbackDate, BuildContext context) async {
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
      final response = await http.post(Uri.parse(createFeedbackUrl),
      headers: {
        'Content-Type' : 'application/json'
      },body: jsonEncode({
          'adminId' : adminId,
          'submissionId' : submissionId,
          'feedBack' : feedback,
          'feedBackDate' : feedbackDate.toIso8601String(),
           }));
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
          return false;
        }else{
          return apiResponse.data;
        }
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server issue')));
    }
    return false;
  }

  Future<FeedbackResponse?> getFeedbackApi(String submissionId, BuildContext context)
  async{
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
      final url = Uri.parse(getFeedbackUrl).replace(queryParameters: {
        'submissionId' : submissionId,
      });
      final response = await http.get(url);

      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
          return null;
        }else{
          final feedback = FeedbackResponse.fromJson(apiResponse.data);
          return feedback;
        }
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server issue')));
      return null;
    }
    return null;
  }
}