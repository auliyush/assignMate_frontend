import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignmentApiService{
  final String getAllAssignmentUrl = "${MyApp.mainUrl}/assignMate/assignment/get/all";
  final String getALlAssignmentOfAdminUrl = "${MyApp.mainUrl}/assignMate/assignment/get/all/by/AdminId";
  final String createAssignUrl = '${MyApp.mainUrl}/assignMate/assignment/create';

  Future<bool> createAssignmentApi(String adminId, String adminName,
      String assignmentName, String assignmentDescription, String assignmentFile,
      DateTime createDate, DateTime dueDate, BuildContext context) async{
    try{
      final response = await http.post(Uri.parse(createAssignUrl),
          headers: {
        'Content-Type' : 'application/json'
          },
        body: jsonEncode({
          "adminName": adminName,
          "assignmentName": assignmentName,
          "assignmentDescription": assignmentDescription,
          "assignmentFile": assignmentFile,
          "createDate": createDate,
          "dueDate": dueDate,
        }));
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        if(apiResponse.data == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(apiResponse.errorMessage)));
          return false;
        }
        print('true');
        return true;
      }
    }on http.ClientException catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server issue')));
      return false;
    }
    return false;
  }

  Future<List<AssignmentResponse>?> getListOfAssignmentApi(BuildContext context) async{
    try{
      final response = await http.get(Uri.parse(getAllAssignmentUrl));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final apiResponseData = ApiResponse.fromJson(jsonData);
        if (apiResponseData.data is List<dynamic>) {
          final listOfAssignments = (apiResponseData.data as List<dynamic>)
              .map((e) => AssignmentResponse.fromJson(e))
              .toList();
          print('Data fetched');
          return listOfAssignments;
        } else {
          final singleAssignment = AssignmentResponse.fromJson(apiResponseData.data);
          print('Single data object fetched');
          return [singleAssignment]; // Return as a list for consistency.
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invailid response from server')));
      }
    }on http.ClientException catch(e){
      print('assignment api - $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Issue try again')));
      return List.empty();
    }on FormatException catch(e){
      print('format - $e');
    }on Exception catch(e){
      print('Exception - $e');
    }
    return List.empty();
  }

  Future<List<AssignmentResponse>?> getListOfAssignmentByAdminIdApi(String adminId, BuildContext context) async{
    try{
      final url = Uri.parse(getAllAssignmentUrl).replace(
          queryParameters: {
            'adminId' : adminId,
          }
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final apiResponseData = ApiResponse.fromJson(jsonData);
        if (apiResponseData.data is List<dynamic>) {
          final listOfAssignments = (apiResponseData.data as List<dynamic>)
              .map((e) => AssignmentResponse.fromJson(e))
              .toList();
          print('Data fetched');
          return listOfAssignments;
        } else {
          final singleAssignment = AssignmentResponse.fromJson(apiResponseData.data);
          print('Single data object fetched');
          return [singleAssignment]; // Return as a list for consistency.
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invailid response from server')));
      }
    }on http.ClientException catch(e){
      print('assignment api - $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Issue try again')));
      return List.empty();
    }on FormatException catch(e){
      print('format - $e');
    }on Exception catch(e){
      print('Exception - $e');
    }
    return List.empty();
  }
}