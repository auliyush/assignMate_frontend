import 'package:assign_mate/DataClasses/user_notification_list.dart';
import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/Screens/notification_card_page.dart';
import 'package:assign_mate/apiServices/notification_api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  late Future<UserNotificationList?> _notificationList;
  NotificationApiService notificationApiService = NotificationApiService();

  @override
  void initState() {
    super.initState();
     _notificationList = notificationApiService.getNotificationApi(
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
              // stack color
              Container(
                height: screenHeight * 0.15,
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
                padding: EdgeInsets.only(left: screenWidth * 0.02, top: screenHeight * 0.1),
                child: Text(
                  'Notifications',
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

                    FutureBuilder<UserNotificationList?>(
                        future: _notificationList,
                        builder: (context, snapshot){
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(
                                child: Text('Something Error'));
                          } else if (!snapshot.hasData || snapshot.data!.notificationResponse.isEmpty) {
                            return const Center(child: Text('No Notifications'));
                          }else{
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.notificationResponse.length,
                                itemBuilder: (context, index){
                                  return NotificationCard(
                                    notificationResponse: snapshot.data!.notificationResponse[index],
                                        // todo api call successfully you have to make a widget only and also
                                    // todo check pdf feedback section
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
      )
    );
  }
}
