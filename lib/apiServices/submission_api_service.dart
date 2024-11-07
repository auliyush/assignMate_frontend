import 'dart:convert';
import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/submission_response.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmissionApiService{

  final String getAllSubmissionByAssignIdUrl = "${MyApp.mainUrl}/assignMate/submission/get/all/by/assignmentId";

  Future<List<SubmissionResponse>?> getAllSubmissionsOfAssignmentApi(String assignmentId,
      BuildContext context) async{
    try{
      final url = Uri.parse(getAllSubmissionByAssignIdUrl).replace(
          queryParameters: {
            'assignmentId' : assignmentId,
          });
      final response = await http.get(url);

      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponseData = ApiResponse.fromJson(jsonData);
        if(apiResponseData.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponseData.data)));
          return null;
        }
        if(apiResponseData.data is List<dynamic>){
          final submissionsList = (apiResponseData.data as List<dynamic>)
              .map((e) => SubmissionResponse.fromJson(e)).toList();
          print('List Fetched');
          return submissionsList;
        }
      }
    }on http.ClientException catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: (Text('Server issue'))));
    }
    return null;
  }

}