class FeedbackResponse{
  String feedback;
  String feedbackDate;

  FeedbackResponse({
    required this.feedback, required this.feedbackDate});

  factory FeedbackResponse.fromJson(Map<String, dynamic> json){
    return FeedbackResponse(
        feedback: json['feedBack'],
        feedbackDate: json['feedBackDate'] as String,
    );
  }
}