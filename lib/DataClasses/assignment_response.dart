import 'package:assign_mate/DataClasses/submission_response.dart';

class AssignmentResponse{
  final String assignmentId;
  final String assignmentName;
  final String assignmentDescription;
  final String creatorName;
  final String createDate;
  final String dueDate;
  final String file;
  List<SubmissionResponse> submissions;

  AssignmentResponse({
    required this.assignmentId,
    required this.assignmentName,
    required this.assignmentDescription,
    required this.creatorName,
    required this.createDate,
    required this.dueDate,
    required this.file,
    required this.submissions});

  factory AssignmentResponse.fromJson(Map<String, dynamic> json){
    List<SubmissionResponse> submission = (
        json['submissions'] as List<dynamic>).map(
            (submissionJson) => SubmissionResponse.fromJson(submissionJson))
        .toList().cast<SubmissionResponse>();
    return AssignmentResponse(
      assignmentId: json['assignmentId'],
    assignmentName: json['assignmentName'],
    assignmentDescription: json['assignmentDescription'],
    creatorName: 'ayush',
    createDate: json['createDate'],
    dueDate: json['dueDate'],
    file: json['assignmentFile'],
    submissions: submission,
  );
  }

}