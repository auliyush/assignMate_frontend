import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/submission_api_service.dart';
import 'package:assign_mate/submission/create_submission_screen.dart';
import 'package:assign_mate/submission/submission_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DataClasses/submission_response.dart';
import '../colors.dart';

class AssignmentDetailScreen extends StatefulWidget {

  final AssignmentResponse assignment;

  const AssignmentDetailScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {

  late Future<SubmissionResponse?> _submission;
  SubmissionApiService submissionApiService = SubmissionApiService();

  @override
  void initState() {
    super.initState();
    _submission = submissionApiService.geSubmissionOfAssignment(
        Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId,
        widget.assignment.assignmentId, context);
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final String assignmentName = widget.assignment.assignmentName;
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          Stack(
            children: [
              // stack image
              Container(
                height: screenHeight * 0.17,
                decoration: const BoxDecoration(
                  color: prColor,
                ),
              ),
              // back button
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.04),
                child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new,color: cdColor),
                ),
              ),
              // assignment name
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.11),
                child: Text(
                  assignmentName.length > 21
                  ? '${assignmentName.substring(0,21)}...'
                      :assignmentName
                  ,
                  style: TextStyle(
                    fontSize: screenWidth <= 750 ? screenWidth * 0.07 : 54,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01,
                        left: screenWidth * 0.02,
                        right: screenWidth * 0.02,
                        bottom: screenHeight * 0.01,
                      ),
                      child: Container(
                        height: screenHeight * 0.4,
                        color: cdColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // assignment name text
                            Container(
                              padding: EdgeInsets.only(left: screenWidth * 0.03, top: screenWidth * 0.03),
                              child: const Text(
                                'Assignment Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            // assignment name
                            Container(
                              padding: EdgeInsets.only(top: screenHeight * 0.005, left: screenWidth * 0.02),
                              height: widget.assignment.assignmentName.length <= 24
                                  ? screenHeight * 0.05
                                  : screenHeight * 0.1,
                              width: screenWidth * 0.96,
                              child: Text(
                                widget.assignment.assignmentName,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.07,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                            // assignment description
                            Container(
                              padding: EdgeInsets.only(
                                  top: screenHeight * 0.01,
                                  left: screenWidth * 0.02
                              ),
                              height: screenHeight * 0.13,
                              child: Text(
                                'Objective - ${widget.assignment.assignmentDescription}',
                                style: const TextStyle(
                                  color: txColor,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    FutureBuilder <SubmissionResponse?>(
                        future: _submission,
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                                child: Text('Something Error'));
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: _buildCreateSubmissionButton(screenHeight,screenWidth),
                            );
                          }else{
                            return SubmissionCardPage(
                                submission: snapshot.data!
                            );
                          }
                        }
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
  Widget _buildCreateSubmissionButton(final screenHeight, final screenWidth){
    return ElevatedButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            CreateSubmissionScreen(assignmentId: widget.assignment.assignmentId)));
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.18),
        backgroundColor: prColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        elevation: 5, // Shadow effect
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
          'Create Submission',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          color: cdColor,
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black12
            )
          ]
        ),
      ),
    );
  }
}

/*

 */
