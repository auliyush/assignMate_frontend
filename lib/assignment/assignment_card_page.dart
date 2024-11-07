import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/admin/admin_assignment_detail_screen.dart';
import 'package:assign_mate/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'assignment_detail_screen.dart';

class AssignmentCardPage extends StatelessWidget {
  final AssignmentResponse assignmentResponse;

  const AssignmentCardPage({
    super.key,
    required this.assignmentResponse,
  });
  @override
  Widget build(BuildContext context) {
    String? loginId = Provider.of<LoginProvider>
      (context, listen: false).loginResponse?.userRole;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if(loginId == 'admin'){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => AdminAssignmentDetailScreen(assignment: assignmentResponse)));
        }else{
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AssignmentDetailScreen(
                      assignment: assignmentResponse)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Container(
          height: screenHeight * 0.13,
          // decoration
          decoration: BoxDecoration(
              color: cdColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 3))
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // assignment icon
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02,
                          top: screenHeight * 0.01),
                      child: Icon(
                        Icons.assignment,
                        color: txColor,
                        size: screenWidth * 0.11,
                      ),
                    ),
                    // assignment details
                    const SizedBox(width: 6),
                    SizedBox(
                      width: screenWidth * 0.63,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // assignment name
                          if (assignmentResponse.assignmentName.length > 20)
                            Container(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.01),
                              width: screenWidth * 0.65,
                              child: Text(
                                '${assignmentResponse.assignmentName.substring(0, 20)}...',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.053,
                                  fontWeight: FontWeight.w600,
                                  color: txColor,
                                ),
                              ),
                            ),
                          if (assignmentResponse.assignmentName.length <= 20)
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              width: screenWidth * 0.6,
                              child: Text(
                                assignmentResponse.assignmentName,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: txColor,
                                ),
                              ),
                            ),
                          // assignment Description
                          if (assignmentResponse.assignmentDescription.length >= 30)
                            Container(
                              padding:
                                  EdgeInsets.only(left: screenWidth * 0.0),
                              width: screenWidth * 0.6,
                              child: Text(
                                '${assignmentResponse.assignmentDescription.substring(0, 30)}....',
                                style: const TextStyle(
                                  color: txColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          if (assignmentResponse.assignmentDescription.length <
                              30)
                            Text(
                              assignmentResponse.assignmentDescription,
                              style: const TextStyle(
                                color: txColor,
                                fontSize: 15,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // assignment button
                    IconButton(
                      onPressed: () {
                        if(loginId == 'admin'){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AdminAssignmentDetailScreen(assignment: assignmentResponse)));
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssignmentDetailScreen(
                                      assignment: assignmentResponse)));
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                // due date and creator name row
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01),
                  child: Row(
                    children: [
                      SizedBox(
                          width: screenWidth * 0.5,
                          child: Text(
                            'By :- ${assignmentResponse.adminName}',
                            style: const TextStyle(
                                color: trColor, fontWeight: FontWeight.w500),
                          )),
                      Text(
                        'Due date :- ${assignmentResponse.dueDate}',
                        style: const TextStyle(
                          color: trColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
