import 'package:assign_mate/DataClasses/notification_response.dart';

class UserNotificationList{
  List<NotificationResponse> notificationResponse;

  UserNotificationList({required this.notificationResponse});

  factory UserNotificationList.fromJson(Map<String, dynamic> json){
    List<NotificationResponse> notifications = (json['notifications'] as List<dynamic>)
        .map((notificationJson) => NotificationResponse.fromJson(notificationJson))
        .toList().cast<NotificationResponse>();
    return UserNotificationList(
        notificationResponse: notifications,
    );
  }
}