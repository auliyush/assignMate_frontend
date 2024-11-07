class AssignmentResponse{
   String assignmentId;
   String assignmentName;
   String assignmentDescription;
   String adminName;
   String adminId;
   String createDate;
   String dueDate;
   String file;

  AssignmentResponse({
    required this.assignmentId,
    required this.assignmentName,
    required this.assignmentDescription,
    required this.adminName,
    required this.adminId,
    required this.createDate,
    required this.dueDate,
    required this.file,});

  factory AssignmentResponse.fromJson(Map<String, dynamic> json){
    return AssignmentResponse(
      assignmentId: json['assignmentId'],
    assignmentName: json['assignmentName'],
    assignmentDescription: json['assignmentDescription'],
      adminName: json['adminName'],
      adminId : json['adminId'],
    createDate: json['createDate'] as String,
    dueDate: json['dueDate'] as String,
    file: json['assignmentFile'],
  );
  }

}