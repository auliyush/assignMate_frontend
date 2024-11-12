import 'dart:io';
import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/Providers/user_provider.dart';
import 'package:assign_mate/apiServices/assignment_api_service.dart';
import 'package:assign_mate/DataClasses/colors.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_bottom_navigation.dart';
import '../apiServices/cloudinary_api_service.dart';
import 'asigned_students_screen.dart';

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
   String fileName = "";
   List<String>? assignedStudentIds = [];

  @override
  void initState() {
    super.initState();
    loginId = Provider.of<LoginProvider>(context,listen: false).loginResponse!.loginId;
  }

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
              height: screenHeight * 0.7,
              child: Column(
                children: [
                  SizedBox(
              height: screenHeight * 0.6,
                    child: Column(
                      children: [
                        // assignment name field
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
                        // assignment description
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
                        // file & date
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // file
                              ElevatedButton(
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
                                // date
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.037
                                  ),
                                ),
                              ),
                            ],
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
                                    fileName.split('/').last,
                                    // Display the file name
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // file
                              ElevatedButton(
                                onPressed: () async{
                                  assignedStudentIds = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context)=>
                                          AssignedStudentsScreen(
                                              assignmentResponse: null,
                                          )));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: seColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04, horizontal: screenWidth * 0.07),
                                ),
                                child: Text(
                                  'Assigned Students',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.037),
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
                          assignedStudentIds ??= List.empty();

                          if (_assignmentController.text.isEmpty ||
                              _assignmentDescription.text.isEmpty ||
                              dueDate == null ||
                              pdfFileUrl == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please Enter Details')),
                            );
                          } else {
                            // Safely access userName
                            String? userName = Provider.of<UserProvider>(context, listen: false).userResponse?.userName;

                            // Ensure userName is not null
                            if (userName == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User name is missing')),);
                              return; // Exit the function if userName is null
                            }
                            AssignmentApiService assignmentApi = AssignmentApiService();
                            bool status = await assignmentApi.createAssignmentApi(
                              loginId, userName, _assignmentController.text,
                              _assignmentDescription.text, pdfFileUrl!, DateTime.now(),
                              dueDate!, assignedStudentIds!, context,
                            );
                            if (status) {
                              _assignmentController.clear();
                              _assignmentDescription.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Assignment Created Successfully')),
                              );
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => AdminBottomNavigation()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to create assignment')),
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
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    String userId = Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId;
    final SupabaseClient supabase = Supabase.instance.client;
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      final file = File(result.files.single.path!);
      final fileN = '$userId/${result.files.single.name}';
      try {
        final response = await supabase.storage.from('assignmatepdf-uploads').upload(fileN, file, fileOptions: const FileOptions(upsert: true));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded successfully')));
        setState(() {
          pdfFileUrl = supabase.storage.from('assignmatepdf-uploads').getPublicUrl(fileN);
          fileName = fileN;
        });
        final fileUrl = supabase.storage.from('assignmatepdf-uploads').getPublicUrl(fileN);
        print('File uploaded successfully: $fileUrl');
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading File')));
        print('Error uploading File: $e');
        Navigator.of(context).pop();
        return;
      }
    }else{
      Navigator.of(context).pop();
      return;
    }
  }

  Future<String> downloadAndSavePdf(String pdfUrl, BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    // Download PDF file using Dio
    final dio = Dio();
    await dio.download(pdfUrl, filePath);

    return filePath;
  }
}
