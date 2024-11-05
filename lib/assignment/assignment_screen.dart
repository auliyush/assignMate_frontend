import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/apiServices/assignment_api_service.dart';
import 'package:assign_mate/assignment/assignment_card_page.dart';
import 'package:assign_mate/colors.dart';
import 'package:flutter/material.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {

  late Future<List<AssignmentResponse>?> _listOfAssignments;
  late AssignmentApiService assignmentApiService;
  @override
  void initState() {
    super.initState();
    assignmentApiService = AssignmentApiService();
    _listOfAssignments = assignmentApiService.getListOfAssignmentApi(context);
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
              Container(
                height: 130,
                decoration: const BoxDecoration(
                  color: prColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 70),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
        ],
      ),
    );
  }
}

/*
AssignmentCardPage(
                      assignmentName: 'Attendance Management System',
                      assignmentDescription: "Develop a system to track, update, "
                          "and report attendance records. The system willallow "
                          "admins and instructors to mark attendance class-wise, "
                          "specify attendance mode (online oroffline), and enable "
                          "students to view their individual attendance report"
                          ' assignment for better experience '
                          'assignment for better experience '
                          'assignment for better experience',
                      assignmentCreatorName: 'ayush verma',
                      assignmentDueDate: '09/11/2024'
                  )
 */
