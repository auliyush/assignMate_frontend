import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/admin/update_assignment_screen.dart';
import 'package:assign_mate/submission/submission_card_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../DataClasses/submission_response.dart';
import '../apiServices/submission_api_service.dart';
import '../DataClasses/colors.dart';
import '../Screens/pdf_screen.dart';

class AdminAssignmentDetailScreen extends StatefulWidget {
  final AssignmentResponse assignment;
  const AdminAssignmentDetailScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<AdminAssignmentDetailScreen> createState() => _AdminAssignmentDetailScreenState();
}


class _AdminAssignmentDetailScreenState extends State<AdminAssignmentDetailScreen> {
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
                  widget.assignment.assignmentName.length > 21
                      ? '${widget.assignment.assignmentName.substring(0,21)}...'
                      :widget.assignment.assignmentName
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
                            Row(
                              mainAxisAlignment : MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: screenWidth * 0.03, top: screenWidth * 0.03),
                                  child: const Text(
                                    'Assignment Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: IconButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => UpdateAssignmentScreen(
                                                assignmentResponse: widget.assignment)));
                                      },
                                      icon: Icon(
                                          Icons.edit,
                                        size: screenWidth * 0.06,
                                        color: txColor,
                                      ),
                                  ),
                                ),
                              ],
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
                            // for pdf viewing but current not able todo make able
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  final filePath = await downloadAndSavePdf(widget.assignment.file,context);
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenPdfViewer(
                                          filename: widget.assignment.file.split('/').last
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
                                        widget.assignment.file.split('/').last
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
                    Text(
                      'List Of Submissions',
                      style: TextStyle(
                          fontSize: screenWidth * 0.037
                      ),
                    ),
                    FutureBuilder<List<SubmissionResponse>?>(
                        future: _listOfSubmissions,
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(
                                child: Text('Something Error'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No Submissions available'));
                          }else{
                            return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index){
                                          return SubmissionCardPage(
                                            submission: snapshot.data![index],
                                          );
                                        }
                                    );
                          }
                        }
                    ),
                  ],
                ),
              )
          )
        ],
      ),
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

