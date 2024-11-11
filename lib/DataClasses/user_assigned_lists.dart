import 'assignment_response.dart';

class UserAssignmentList{
  List<AssignmentResponse> assignmentList;

  UserAssignmentList({
   required this.assignmentList,
});

  factory UserAssignmentList.fromJson(Map<String, dynamic> json){
    List<AssignmentResponse> assignmentsList =  (json['assignmentList'] as List<dynamic>).map((assignmentJson) =>
        AssignmentResponse.fromJson(assignmentJson)).toList().cast<AssignmentResponse>();
    return UserAssignmentList(
        assignmentList: assignmentsList,
    );
  }
}