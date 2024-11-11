import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/assignment_api_service.dart';
import 'package:assign_mate/assignment/assignment_card_page.dart';
import 'package:assign_mate/DataClasses/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminAssignmentScreen extends StatefulWidget {
  const AdminAssignmentScreen({super.key});

  @override
  State<AdminAssignmentScreen> createState() => _AdminAssignmentScreenState();
}

class _AdminAssignmentScreenState extends State<AdminAssignmentScreen> {

  late Future<List<AssignmentResponse>?> _listOfAssignments;
  late AssignmentApiService assignmentApiService;
  late String userId;
  @override
  void initState() {
    super.initState();
    userId = Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId;
    assignmentApiService = AssignmentApiService();
      _listOfAssignments = assignmentApiService.getListOfAssignmentApi(userId, context);
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
            child: FutureBuilder<List<AssignmentResponse>?>(
                future: _listOfAssignments,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Something Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Assignments available'));
                  } else {
                    List<AssignmentResponse> assignments = snapshot.data!;
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
