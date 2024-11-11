import 'dart:io';

import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/admin/update_assignment_screen.dart';
import 'package:assign_mate/submission/submission_card_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import '../DataClasses/submission_response.dart';
import '../apiServices/submission_api_service.dart';
import '../colors.dart';
import 'package:http/http.dart' as http;

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
  bool _isPdfLoading = true;
  bool _isValidPdf = false;

  @override
  void initState() {
    super.initState();
    _listOfSubmissions = submissionApiService.getAllSubmissionsOfAssignmentApi(widget.assignment.assignmentId, context);
    // _checkPdfAvailability();
  }
  void _checkPdfAvailability() async{
    try{
      final pdf = await PdfDocument.openAsset(widget.assignment.file);
      if(pdf.pagesCount > 0){
        setState(() {
          _isPdfLoading = false;
          _isValidPdf = true;
        });
      }else{
        throw Exception("PDF is empty or invalid");
      }
    }catch(e){
      setState(() {
        _isValidPdf = false;
        _isPdfLoading = false;
      });
    }
  }

  Future<void> _openPdf() async {
    final Uri pdfUri = Uri.parse(widget.assignment.file);
    if (await canLaunchUrl(pdfUri)) {
      await launchUrl(pdfUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open PDF")),
      );
    }
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
                            ElevatedButton(
                                onPressed: (){

                                },
                                child: Text('Tap Here'),
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
  void downloadPdf(String pdfUrl) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //String pdfUrl = 'https://res.cloudinary.com/YOUR_CLOUD_NAME/raw/upload/v1234567890/sample.pdf';
    File? pdfFile = await downloadPdfFromCloudinary(pdfUrl, 'my_pdf');

    if (pdfFile != null) {
      print('PDF downloaded to: ${pdfFile.path}');
      Navigator.of(context).pop();
    } else {
      print('Failed to download PDF.');
      Navigator.of(context).pop();
    }
  }
  Future<File?> downloadPdfFromCloudinary(String pdfUrl, String fileName) async {
    try {
      // Request the PDF file from Cloudinary
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        // Get the device's temporary directory
        final directory = await getTemporaryDirectory();

        // Create a file with the specified filename
        final file = File('${directory.path}/$fileName.pdf');

        // Write the PDF bytes to the file
        await file.writeAsBytes(response.bodyBytes);

        // Return the file
        return file;
      } else {
        print('Failed to download PDF: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }
}