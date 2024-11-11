import 'package:assign_mate/DataClasses/feedback_response.dart';
import 'package:assign_mate/DataClasses/submission_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/feedback_api_service.dart';
import 'package:assign_mate/apiServices/submission_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../DataClasses/colors.dart';
import '../Screens/pdf_screen.dart';
import 'admin_assignment_detail_screen.dart';

class AdminSubmissionDetailScreen extends StatefulWidget {
  SubmissionResponse submission;
   AdminSubmissionDetailScreen({
    super.key,
    required this.submission
  });

  @override
  State<AdminSubmissionDetailScreen> createState() => _AdminSubmissionDetailScreenState();
}

class _AdminSubmissionDetailScreenState extends State<AdminSubmissionDetailScreen> {
  String? selectedOption;
  String finalSelection = "";
   FeedbackResponse? feedbackResponse;
   final _feedbackController = TextEditingController();
  FeedbackApiService feedbackApiService = FeedbackApiService();
  SubmissionApiService submissionApiService = SubmissionApiService();
  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    feedbackResponse = await feedbackApiService.getFeedbackApi(widget.submission.submissionId, context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                    widget.submission.submissionTitle.length > 21
                        ? '${widget.submission.submissionTitle.substring(0,21)}...'
                        :widget.submission.submissionTitle
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                    // submission title text & status
                    Row(
                      mainAxisAlignment : MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: screenWidth * 0.03, top: screenWidth * 0.03),
                          child: const Text(
                            'Submission Title',
                            style: TextStyle(
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
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
                    // assignment name
                    Container(
                      padding: EdgeInsets.only(top: screenHeight * 0.005, left: screenWidth * 0.02),
                      height: widget.submission.submissionTitle.length <= 24
                          ? screenHeight * 0.05
                          : screenHeight * 0.1,
                      width: screenWidth * 0.96,
                      child: Text(
                        widget.submission.submissionTitle,
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
                        'Objective - ${widget.submission.submissionDescription}',
                        style: const TextStyle(
                          color: txColor,
                        ),
                      ),
                    ),
                    // for pdf viewing but current not able todo make able
                    Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            final filePath = await downloadAndSavePdf(widget.submission.file,context);
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenPdfViewer(
                                    filename: widget.submission.file.split('/').last
                                    ,filePath: filePath),
                              ),
                            );
                          },
                          child: Container(
                            height: screenHeight * 0.08,
                            width: screenWidth * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: bgColor,
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: screenWidth * 0.02, left: screenWidth * 0.02),
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                    size: screenWidth * 0.12,
                                  ),
                                ),
                                Text(
                                    widget.submission.file.split('/').last
                                )
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            ),
            // feedback
            if(feedbackResponse != null)
            Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                ),
                    child: Container(
                      color: cdColor,
                      height: screenHeight * 0.1,
                      width: screenWidth,
                      child: Text(
                        'Feedback - ${feedbackResponse!.feedback}'
                      ),
                    ),
            ),
            if(Provider.of<LoginProvider>(context, listen: false).loginResponse!.userRole == 'admin' &&
                feedbackResponse == null)
              Container(
                margin: EdgeInsets.only(
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 3, // Blur radius
                      offset: Offset(0, 3), // Offset in x and y direction
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    hintText: 'Give Feedback...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    fillColor: cdColor,
                    filled: true,
                    prefixIcon: Icon(Icons.feed),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
        
                  ),
                ),
              ),
            // status
            if(widget.submission.submissionStatus == "Pending" &&
                Provider.of<LoginProvider>(context, listen: false).loginResponse!.userRole == 'admin')
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.04),
              child: Row(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.5,
                      child: RadioListTile<String>(
                        title: Text("Reviewed"),
                        value: "Reviewed",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.5,
                      child: RadioListTile<String>(
                        title: Text("Rejected"),
                        value: "Rejected",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
            ),
            // todo feedback pdf after giving show asa well as
            if(widget.submission.submissionStatus == "Pending" &&
            Provider.of<LoginProvider>(context, listen: false).loginResponse!.userRole == 'admin')
            Align(
              child: ElevatedButton(
                  onPressed: () async{
                    if(_feedbackController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please give Feedback')));
                    }else if(selectedOption == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please Select Status')));
                    }else {
                      await feedbackApiService.createFeedbackApi(
                          Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId,
                          widget.submission.submissionId, _feedbackController.text,
                          DateTime.now(), context);
                      await submissionApiService.updateSubmissionStatusApi(
                          Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId,
                        widget.submission.submissionId, selectedOption!, context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated')));
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminSubmissionDetailScreen(submission: widget.submission),
                      ));
                    }
                  },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.18),
                  backgroundColor: prColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: widget.submission.submissionStatus == "Pending"
                    ? Text(
                        'Update',
                        style: TextStyle(
                          color: cdColor,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : null),
          ),
          ],
        ),
      )
    );
  }
  Future<String> downloadAndSavePdf(String pdfUrl, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/218632515_money-transfer_19102024';

    // Download PDF file using Dio
    final dio = Dio();
    await dio.download(pdfUrl, filePath);
    Navigator.of(context).pop();
    return filePath;
  }
}
