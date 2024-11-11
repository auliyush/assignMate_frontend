import 'package:assign_mate/DataClasses/submission_response.dart';
import 'package:assign_mate/DataClasses/user_response.dart';
import 'package:assign_mate/admin/admin_submission_detail_screen.dart';
import 'package:assign_mate/apiServices/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/login_provider.dart';
import '../DataClasses/colors.dart';

class SubmissionCardPage extends StatefulWidget {
  final SubmissionResponse submission;

  const SubmissionCardPage({super.key, required this.submission});

  @override
  State<SubmissionCardPage> createState() => _SubmissionCardPageState();
}

class _SubmissionCardPageState extends State<SubmissionCardPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchUserName(widget.submission.userId);
  // }
  // Future<void> _fetchUserName(String userId) async {
  //   UserApiService userApiService = UserApiService();
  //   UserResponse? user = await userApiService.getUserByIdApi(userId, context);
  //   if (user != null) {
  //     setState(() {
  //       userName = user.userName;
  //     });
  //   } else {
  //     setState(() {
  //       userName = 'User not found';
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            AdminSubmissionDetailScreen(submission: widget.submission)));
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: screenWidth * 0.019, right: screenWidth * 0.019),
        child: Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          height: screenHeight * 0.19,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name & status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // name container
                  Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.04),
                      width: screenWidth * 0.6,
                      child: widget.submission.userName.length > 25
                          ? Text(
                              '${widget.submission.userName.substring(0, 25)}...',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: txColor,
                                decoration: TextDecoration.underline,
                                decorationColor: seColor,
                                decorationThickness: 1.5,
                              ),
                            )
                          : Text(
                        widget.submission.userName,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: txColor,
                                decoration: TextDecoration.underline,
                                decorationColor: seColor,
                                decorationThickness: 1.5,
                              ),
                            )),
                  // status container
                  Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.0),
                      width: screenWidth * 0.27,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: widget.submission.submissionStatus == 'Reviewed'
                                ? Colors.green
                                : widget.submission.submissionStatus == 'Pending'
                                    ? Colors.yellow
                                    : Colors.red,
                            radius: 6,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            widget.submission.submissionStatus,
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: txColor),
                          ),
                        ],
                      )),
                ],
              ),
              // title
              Container(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.04, top: screenHeight * 0.01),
                child: widget.submission.submissionTitle.length > 19
                    ? Text(
                        '${widget.submission.submissionTitle.substring(0, 19)}....',
                        style: TextStyle(
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.w700),
                      )
                    : Text(widget.submission.submissionTitle),
              ),
              // description
              Container(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.044, top: screenHeight * 0.001),
                child: widget.submission.submissionDescription.length > 29
                    ? Text(
                        '${widget.submission.submissionDescription.substring(0, 29)}....',
                        style: TextStyle(
                            fontSize: screenWidth * 0.036,
                            fontWeight: FontWeight.w700),
                      )
                    : Text(widget.submission.submissionDescription),
              ),
              // date and view detail
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.044, top: screenHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submit On - ${widget.submission.submissionDate}',
                      style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View Details >>',
                          style: TextStyle(color: trColor),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
