
class SubmissionResponse{
   String submissionId;
   String userId;
   String assignmentId;
   String submissionTitle;
   String submissionDescription;
   String file;
   String submissionDate;
   String submissionStatus;

  SubmissionResponse({
    required this.submissionId,
    required this.userId,
    required this.assignmentId,
    required this.submissionTitle,
    required this.submissionDescription,
    required this.file,
    required this.submissionDate,
    required this.submissionStatus});

  factory SubmissionResponse.fromJson(Map<String, dynamic> json){
    return SubmissionResponse(
        submissionId: json['submissionId'],
        userId: json['userId'],
        assignmentId: json['assignmentId'],
        submissionTitle: json['submissionTitle'],
        submissionDescription: json['submissionDescription'],
        file: json['file'],
        submissionDate: json['submissionDate'] as String,
        submissionStatus: json['submissionStatus']
    );
  }
}