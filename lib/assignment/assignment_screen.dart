import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/DataClasses/user_assigned_lists.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/Providers/user_provider.dart';
import 'package:assign_mate/apiServices/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataClasses/colors.dart';
import 'assignment_card_page.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {

  late Future<UserAssignmentList?> _listOfAssignments;
  late UserApiService userApiService;

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService();
    String userId = Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId;
    _listOfAssignments = userApiService.getAssignedAssignmentApi(userId, context);
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Stack(
            children: [
              // container color
              Container(
                height: screenHeight * 0.14,
                decoration: const BoxDecoration(
                  color: prColor,
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight * 0.07),
                child: Text(
                  "Assignments",
                  style: TextStyle(
                    fontSize: screenWidth <= 750 ? screenWidth * 0.08 : 54,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(3.0, 3.0), // X and Y offset for the shadow
                        blurRadius: 8.0, // Blur effect for the shadow
                        color: Colors.black12.withOpacity(0.7), // Shadow color and opacity
                        // todo here
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<UserAssignmentList?>(
              future: _listOfAssignments,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Something Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.assignmentList.isEmpty) {
                  return const Center(child: Text('No Assignments available'));
                } else {
                  List<AssignmentResponse> assignments = snapshot.data!.assignmentList;
                  return ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (context, index){
                        return AssignmentCardPage(
                          assignmentResponse: assignments[index],
                        );
                      }
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
