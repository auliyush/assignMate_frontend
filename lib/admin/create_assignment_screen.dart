import 'dart:io';

import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/assignment_api_service.dart';
import 'package:assign_mate/apiServices/cloudinary_api_service.dart';
import 'package:assign_mate/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _assignmentController = TextEditingController();
  final _assignmentDescription = TextEditingController();
  String? pdfFileUrl;
  DateTime? dueDate;
   late String loginId;
  @override
  void initState() {
    // TODO: implement initState
    loginId = Provider.of<LoginProvider>(context,listen: false).loginResponse!.loginId;
  }

  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Allow only PDF files
    );
    if (result != null && result.files.isNotEmpty) {
      // Convert the file from the result to a File object
      File pickedFile = File(result.files.single.path!);

      // Call your Cloudinary upload method
      CloudinaryApiService cloudinaryApiService = CloudinaryApiService();
      String? pdfUrl = await cloudinaryApiService.uploadPdfToCloudinary(pickedFile);
      if (pdfUrl != null) {
        setState(() {
          pdfFileUrl = pdfUrl; // Display file name
        });
        print('PDF uploaded successfully: $pdfUrl');
      } else {
        print('Failed to upload PDF');
      }
    }
  }

  // todo uncomplete create assign api and page

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              // assignment name
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.11),
                child: Text(
                'Create Assignment',
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
            height: screenHeight * 0.4,
            color: cdColor,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _assignmentController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter Assignment Name';
                      }else if(value.length < 15){
                        return 'Please Enter valid assignment name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      hintText: 'Assignment Name',
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _assignmentDescription,
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
                      hintText: 'Assignment description',
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
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: pickPdfFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: seColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.07),
                          ),
                          child: Text(
                            pdfFileUrl ?? 'Select PDF File',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(), // Set to today to prevent selecting past dates
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dueDate = pickedDate;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.07),
                        ),
                        child: Text(
                          dueDate != null
                              ? '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                              : 'Select Date',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: (){
                        if(_assignmentController.text.isEmpty ||
                            _assignmentDescription.text.isEmpty||
                        dueDate == null || pdfFileUrl == null
                        ){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please Enter Details')));
                        }else{
                          AssignmentApiService assignmentApi = AssignmentApiService();
                          assignmentApi.createAssignmentApi(
                              loginId, 'Ayush Verma',
                              _assignmentController.text,
                              _assignmentDescription.text,
                              pdfFileUrl!, DateTime.now() ,dueDate!, context);

                          _assignmentController.clear();
                          _assignmentDescription.clear();
                          dueDate = null;
                          pdfFileUrl= null;
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
    );
  }
}
