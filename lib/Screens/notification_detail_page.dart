import 'package:assign_mate/DataClasses/notification_response.dart';
import 'package:assign_mate/DataClasses/colors.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  NotificationResponse notificationResponse;

  NotificationPage({required this.notificationResponse});

  void showNotification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,  // Allow full-screen height if needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Title
              Text(
                notificationResponse.notificationTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // Notification Description
              Text(
                notificationResponse.notificationDescription,
                style: TextStyle(
                  fontSize: 16,
                ),
                softWrap: true,
              ),
              SizedBox(height: 12),

              // Notification DateTime
              Text(
                "${notificationResponse.notificationDate}     ${notificationResponse.notificationTime}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Notification')),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.01,
            right: screenWidth * 0.01,
            bottom: screenHeight * 0.03,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Title
                  Text(
                    notificationResponse.notificationTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Notification Description
                  Text(
                    notificationResponse.notificationDescription,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                  SizedBox(height: 12),

                  // Notification DateTime
                  Text(
                    "${notificationResponse.notificationDate}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}