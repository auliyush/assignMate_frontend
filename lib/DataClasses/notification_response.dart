class NotificationResponse{
  String notificationId;
  String notificationTitle;
  String notificationDescription;
  String notificationDate;
  String notificationTime;

  NotificationResponse({
      required this.notificationId,
    required this.notificationTitle,
    required this.notificationDescription,
    required this.notificationDate,
    required this.notificationTime});

  factory NotificationResponse.fromJson(Map<String, dynamic> json){
    return NotificationResponse(
        notificationId: json['notificationId'],
        notificationTitle: json['notificationTitle'],
        notificationDescription: json['notificationDescription'],
        notificationDate: json['notificationDate'] as String,
        notificationTime: json['notificationTime'] as String,
    );
  }
}