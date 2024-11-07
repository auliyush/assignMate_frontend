import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/apiServices/submission_api_service.dart';
import 'package:flutter/material.dart';
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

  late Future<List<SubmissionResponse>?> _listOfSubmissions;
  SubmissionApiService submissionApiService = SubmissionApiService();

  @override
  void initState() {
    super.initState();
    _listOfSubmissions = submissionApiService.getAllSubmissionsOfAssignmentApi(widget.assignment.assignmentId, context);
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
              child: FutureBuilder<List<SubmissionResponse>?>(
                  future: _listOfSubmissions,
                  builder: (context, snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Center(
                          child: Text('Something Error'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Submissions available'));
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                          itemBuilder: (context, index){
                            return null;
                            // todo implement submission card
                          }
                      );
                    }
                  }
              )
          ),
        ],
      ),
    );
  }
}
