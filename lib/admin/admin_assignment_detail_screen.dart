import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/submission/submission_card_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DataClasses/submission_response.dart';
import '../apiServices/submission_api_service.dart';
import '../colors.dart';

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
                            Container(
                              padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenWidth * 0.03),
                              child: const Text(
                                  'Assignment Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            // assignment name
                            Container(
                              padding: EdgeInsets.only(top: screenHeight * 0.005),
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
                            // PDF container //todo this is not complete because cloudinary not exist
                            // Container(
                            //   padding: EdgeInsets.all(16),
                            //   child: _isPdfLoading
                            //   ? const CircularProgressIndicator(color: seColor)
                            //       : GestureDetector(
                            //     onTap: _openPdf,
                            //     child: CachedNetworkImage(
                            //       imageUrl: 'https://example.com/path/to/pdf-thumbnail.jpg', // Replace with your thumbnail URL
                            //       placeholder: (context, url) => CircularProgressIndicator(),
                            //       errorWidget: (context, url, error) => Icon(Icons.picture_as_pdf, color: Colors.red, size: 60),
                            //     ),
                            //   )
                            //   ,
                            // )
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
}
