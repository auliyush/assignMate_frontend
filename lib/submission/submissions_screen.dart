import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/submission_api_service.dart';
import 'package:assign_mate/submission/submission_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DataClasses/submission_response.dart';
import '../DataClasses/colors.dart';

class SubmissionsScreen extends StatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {

  late Future<List<SubmissionResponse>?> _listOfSubmission;
  SubmissionApiService submissionApiService = SubmissionApiService();
  @override
  void initState() {
    super.initState();
    _listOfSubmission = submissionApiService.getAllSubmissionOfUserApi(
        Provider.of<LoginProvider>(context, listen: false).loginResponse!.loginId, context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
              // submission text
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.11),
                child: Text(
                  'My Submissions',
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
                    FutureBuilder<List<SubmissionResponse>?>(
                        future: _listOfSubmission,
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
