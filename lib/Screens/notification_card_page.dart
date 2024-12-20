import 'package:assign_mate/DataClasses/notification_response.dart';
import 'package:flutter/material.dart';

import 'notification_detail_page.dart';

class NotificationCard extends StatelessWidget {
  final NotificationResponse notificationResponse;

  NotificationCard({
    required this.notificationResponse,
  });

  String getShortTitle() {
    return notificationResponse.notificationTitle.length > 19
        ? '${notificationResponse.notificationTitle.substring(0, 19)}...'
        : notificationResponse.notificationTitle;
  }

  String getShortDescription() {
    return notificationResponse.notificationDescription.length > 21
        ? '${notificationResponse.notificationDescription.substring(0, 21)}..'
        : notificationResponse.notificationDescription;
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(notificationResponse:  notificationResponse)));
      },
      onLongPress: () => _showDeleteConfirmation(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getShortTitle(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045
                ),
              ),
              const SizedBox(height: 8),
              Text(
                getShortDescription(),
                style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey.shade700
                ),
              ),
              const SizedBox(height: 8),
              Text(
               '${notificationResponse.notificationDate}       '
                   '${notificationResponse.notificationTime.split('.').first}',
                style: TextStyle(
                    fontSize: screenWidth * 0.029,
                    color: Colors.grey.shade700
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Notification'),
          content: const Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {

                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
