import 'dart:convert';
import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/submission_response.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmissionApiService{

  final String getAllSubmissionByAssignIdUrl = "${MyApp.mainUrl}/assignMate/submission/get/all/by/assignmentId";
  final String getSubmissionOfAssignUrl = '${MyApp.mainUrl}/assignMate/submission/get/by/user/assignment/Id';
  final String createSubmissionUrl = '${MyApp.mainUrl}/assignMate/submission/create';
  final String updateSubmissionStatusUrl = '${MyApp.mainUrl}/assignMate/submission/update/submission/status';
  final String getALlSubmissionOfUserUrl = '${MyApp.mainUrl}/assignMate/submission/get/all/by/userId';


  Future<bool?> createSubmissionApi(String userId, String userName,
      String assignmentId, String submissionTitle, String submissionDescription,
      String file, DateTime submissionDate, BuildContext context) async{
    try{
      final response = await http.post(Uri.parse(createSubmissionUrl),
          headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({
          'userId' : userId,
          'userName' : userName,
          'assignmentId' : assignmentId,
          'submissionTitle' : submissionTitle,
          'submissionDescription' : submissionDescription, 
          'file' : file,
          'submissionDate' : submissionDate.toIso8601String(),
        })
      );
      
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
        }else{
          return apiResponse.data;
        }
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server issue')));
    }
    return null;
  }

  // for admin
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

  // for user
  Future<List<SubmissionResponse>?> getAllSubmissionOfUserApi(String userId,
      BuildContext context) async {
    try{
      final url = Uri.parse(getALlSubmissionOfUserUrl).replace(
          queryParameters: {
            'userId' : userId,
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
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server issue')));
    }
    return null;
  }

// for user
  Future<SubmissionResponse?> geSubmissionOfAssignment(String userId, String assignmentId,
      BuildContext context) async{
    try{
      final url = Uri.parse(getSubmissionOfAssignUrl).replace(
          queryParameters: {
            'userId' : userId,
            'assignmentId' : assignmentId
          });

      final response = await http.get(url);
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          return null;
        }else{
          final submissionResponse = SubmissionResponse.fromJson(apiResponse.data);
          return submissionResponse;
        }
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server issue')));
    }
    return null;
  }

  Future<bool> updateSubmissionStatusApi(String adminId, String submissionId,
      String status, BuildContext context) async{
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
      final response = await http.put(Uri.parse(updateSubmissionStatusUrl),
          headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({
          'adminId' : adminId,
          'submissionId' : submissionId,
          'status' : status
        })
      );

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
      }else{
        print(response.statusCode);
      }
    }on http.ClientException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server issue')));
    }
    return false;
  }

}