import 'dart:io';

import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/submission_api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Providers/user_provider.dart';
import '../apiServices/assignment_api_service.dart';
import '../apiServices/cloudinary_api_service.dart';
import '../DataClasses/colors.dart';

class CreateSubmissionScreen extends StatefulWidget {
  String assignmentId;
   CreateSubmissionScreen({
    super.key,
    required this.assignmentId
  });

  @override
  State<CreateSubmissionScreen> createState() => _CreateSubmissionScreenState();
}

class _CreateSubmissionScreenState extends State<CreateSubmissionScreen> {

  final _submissionTitleController = TextEditingController();
  final _submissionDescriptionController = TextEditingController();
  String? pdfFileUrl;
  String fileName = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: cdColor,
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
                // assignment name
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.11),
                  child: Text(
                    'Submission',
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
            Container(
                height: screenHeight * 0.7,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.6,
                      child: Column(
                        children: [
                          // submission title field
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _submissionTitleController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please Enter Submission Title';
                                }else if(value.length < 15){
                                  return 'Please Enter valid Submission Title';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 18),
                                hintText: 'Submission Title',
                                hintStyle: TextStyle(
                                    color: bgColor,
                                    fontSize: screenWidth * 0.04
                                ),
                                fillColor: Colors.black.withOpacity(0.2),
                                filled: true,
                                prefixIcon: Icon(Icons.assignment,size: screenWidth * 0.07,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          // assignment description
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _submissionDescriptionController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please Enter Description';
                                }else if(value.length < 15){
                                  return 'Please Enter valid Description';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 18),
                                hintText: 'Submission description',
                                hintStyle: TextStyle(
                                    color: bgColor,
                                    fontSize: screenWidth * 0.04
                                ),
                                fillColor: Colors.black.withOpacity(0.2),
                                filled: true,
                                prefixIcon: Icon(Icons.assignment,size: screenWidth * 0.07,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          // file & date
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: uploadFile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: seColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.07),
                              ),
                              child: Text(
                                pdfFileUrl == null
                                    ? 'Select PDF File'
                                    : 'Pdf selected',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.037),
                              ),
                            ),
                          ),
                          if(pdfFileUrl != null)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf, // PDF icon
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      fileName,
                                      // Display the file name
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // submit
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Check empty fields or null values
                            if (_submissionTitleController.text.isEmpty ||
                                _submissionDescriptionController.text.isEmpty ||
                                pdfFileUrl == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please Enter Details')),
                              );
                            } else {
                              // getting userName
                              String? userName = Provider.of<UserProvider>(context, listen: false).userResponse?.userName;
                              SubmissionApiService submissionApi = SubmissionApiService();
                              bool? success = await submissionApi.createSubmissionApi(
                                  Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId,
                                  userName!, widget.assignmentId, _submissionTitleController.text,
                                  _submissionDescriptionController.text,
                                  pdfFileUrl!, DateTime.now(), context);
                              // Check if the assignment creation was successful
                              if (success!) {
                                // Clear text fields only after success
                                _submissionTitleController.clear();
                                _submissionDescriptionController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Submission Submitted Successfully')));
                                // Navigate to AdminBottomNavigation
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to Submitted Submission')),
                                );
                              }
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.18),
                            backgroundColor: prColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:  Text(
                            'Create',
                            style: TextStyle(
                              color: cdColor,
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
  Future<void> uploadFile() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      try {
        final response = await supabase.storage.from('assignmatepdf-uploads').upload(fileName, file);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded successfully')));
        setState(() {
          pdfFileUrl = supabase.storage.from('assignmatepdf-uploads').getPublicUrl(fileName);
        });
        print('File uploaded successfully: $pdfFileUrl');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading file')));
        print('Error uploading file: $e');
      }
    }
  }
}
