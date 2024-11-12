import 'dart:io';

import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/admin/asigned_students_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Providers/login_provider.dart';
import '../apiServices/assignment_api_service.dart';
import '../DataClasses/colors.dart';

class UpdateAssignmentScreen extends StatefulWidget {
  final AssignmentResponse assignmentResponse;
  const UpdateAssignmentScreen({
    super.key,
    required this.assignmentResponse
  });

  @override
  State<UpdateAssignmentScreen> createState() => _UpdateAssignmentScreenState();
}

class _UpdateAssignmentScreenState extends State<UpdateAssignmentScreen> {
  final _assignmentController = TextEditingController();
  final _assignmentDescription = TextEditingController();
  String? pdfFileUrl;
  DateTime? dueDate;
  late String adminId;
  String fileName = "";
  late List<String>? assignedStudentIds;
  @override
  void initState() {
    super.initState();
    _assignmentController.text = widget.assignmentResponse.assignmentName;
    _assignmentDescription.text = widget.assignmentResponse.assignmentDescription;
    pdfFileUrl = widget.assignmentResponse.file;
    dueDate = DateTime.parse(widget.assignmentResponse.dueDate) ;
    adminId = widget.assignmentResponse.adminId;
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
                // update text
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.11),
                  child: Text(
                    'Update Assignment',
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
            SizedBox(
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
                                      pdfFileUrl!.split('/').last,
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
                                    assignedStudentIds = await Navigator.push(context, MaterialPageRoute(builder: (context)=> AssignedStudentsScreen(assignmentResponse: widget.assignmentResponse)));
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
                          onPressed: (){
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            if(_assignmentController.text.isEmpty ||
                                _assignmentDescription.text.isEmpty||
                                dueDate == null || pdfFileUrl == null
                            ){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please Enter Details')));
                              Navigator.pop(context);
                            }else{
                              AssignmentApiService assignmentApi = AssignmentApiService();
                              assignmentApi.updateAssignmentApi(
                                  adminId, widget.assignmentResponse.assignmentId,
                                  _assignmentController.text,
                                  _assignmentDescription.text,
                                  pdfFileUrl!,dueDate!,assignedStudentIds!, context);

                              _assignmentController.clear();
                              _assignmentDescription.clear();
                              Navigator.pop(context);
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
                            'Update',
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
        builder: (BuildContext context){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
    String userId = Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId;
    final SupabaseClient supabase = Supabase.instance.client;
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      final file = File(result.files.single.path!);
      final fileName = '$userId/${result.files.single.name}';
      try {
        final response = await supabase.storage.from('assignmatepdf-uploads')
            .upload(fileName, file, fileOptions: const FileOptions(upsert: true));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File uploaded successfully')));
        setState(() {
          pdfFileUrl = supabase.storage.from('assignmatepdf-uploads').getPublicUrl(fileName);
        });
        print('File uploaded successfully: $pdfFileUrl');
        return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading file')));
        print('Error uploading file: $e');
        return;
      }
    }else{
      Navigator.of(context).pop();
      return;
    }
  }
}
