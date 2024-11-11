import 'package:assign_mate/apiServices/user_api_service.dart';
import 'package:flutter/material.dart';

import '../DataClasses/assignment_response.dart';
import '../DataClasses/user_response.dart';
import '../DataClasses/colors.dart';

class AssignedStudentsScreen extends StatefulWidget {
  final AssignmentResponse? assignmentResponse;
  const AssignedStudentsScreen({
    super.key,
    required this.assignmentResponse
  });

  @override
  State<AssignedStudentsScreen> createState() => _AssignedStudentsScreenState();
}

class _AssignedStudentsScreenState extends State<AssignedStudentsScreen> {

  late Future<List<UserResponse>?> _studentsList;
  late UserApiService userApiService;
  List<String> assignedStudentIds = [];

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService();
    _studentsList = userApiService.getListOfStudentsApi(context);
  }

  void selectStudents(String studentId){
    setState(() {
      if(assignedStudentIds.contains(studentId)){
        assignedStudentIds.remove(studentId);
      }else{
        assignedStudentIds.add(studentId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
              // text
              Padding(
                padding:  EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight * 0.07),
                child: Text(
                  "Assigned Students",
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
            child: FutureBuilder<List<UserResponse>?>(
              future: _studentsList,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Something Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Students available'));
                } else {
                  List<UserResponse> students = snapshot.data!;
                  return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index){
                        return StudentCard(
                            user: students[index],
                            assignment: widget.assignmentResponse,
                          addStudents: selectStudents,
                        );
                      }
                  );
                }
              },
            ),
          ),
          Container(
            height: screenHeight * 0.07,
            width: screenWidth * 0.5,
            margin: EdgeInsets.only(bottom: screenHeight * 0.05),
            child: _buildApplyButton(),
          )
        ],
      ),
    );
  }
  Widget _buildApplyButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: seColor,
        elevation: 2,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        // Pop with the list of assigned student IDs
        Navigator.pop(context, assignedStudentIds);
      },
      child: Text(
          'Assigned',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.027
        ),
      ),
    );
  }
}

class StudentCard extends StatefulWidget {
  UserResponse user;
  AssignmentResponse? assignment;
  ValueChanged<String> addStudents;
   StudentCard({
    super.key,
    required this.user,
    required this.assignment,
     required this.addStudents,
  });

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  late bool isAssigned;
  late bool temporaryAssigned;
  @override
  void initState() {
    super.initState();
    if(widget.assignment != null){
      isAssigned = widget.assignment!.studentsId.contains(widget.user.userId);
      temporaryAssigned = isAssigned;
    }else{
      isAssigned = false;
      temporaryAssigned = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Text(
                  widget.user.userName,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    color: seColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.06),

                child: _buildAssignButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildAssignButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isAssigned
            ? seColor
            : temporaryAssigned ? seColor : Colors.grey,
        elevation: 0,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
        onPressed: () {
          setState(() {
            temporaryAssigned = !temporaryAssigned;
          });
          widget.addStudents(widget.user.userId);
        },
      child: isAssigned
        ? Text(
        'Assigned')
          : temporaryAssigned ?
          Text('Assigned')
          : Text('Assign')
    );
  }
}

