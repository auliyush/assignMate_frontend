import 'dart:convert';

import 'package:assign_mate/DataClasses/api_response.dart';
import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignmentApiService{
  final String getAllAssignmentUrl = "${MyApp.mainUrl}/assignMate/assignment/get/all";

  Future<List<AssignmentResponse>?> getListOfAssignmentApi(BuildContext context) async{
    try{
      final response = await http.get(Uri.parse(getAllAssignmentUrl));
      if(response.statusCode == 200){
        final jsonData = jsonDecode(response.body);
        final apiResponseData = ApiResponse.fromJson(jsonData);
        if(apiResponseData.data is List<dynamic>){
          final listOfAssignments = apiResponseData.data.map((e) =>
              AssignmentResponse.fromJson(e)).toList();
          print('data fetched');
          return listOfAssignments!;
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invailid response from server')));
      }
    }on http.ClientException catch(e){
      print('assignment api - $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Issue try again')));
      return List.empty();
    }
    return List.empty();
  }
  // todo fix this api list having null value
// todo type null is not subtype of list dynamic something null comes
}