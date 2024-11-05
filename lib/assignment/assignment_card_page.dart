import 'package:assign_mate/DataClasses/assignment_response.dart';
import 'package:assign_mate/colors.dart';
import 'package:flutter/material.dart';

class AssignmentCardPage extends StatelessWidget {
  final AssignmentResponse assignmentResponse;
  const AssignmentCardPage({
    super.key,
    required this.assignmentResponse,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: (){
            
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: cdColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 3)
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0,top: 21),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // assignment icon
                        const Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Icon(
                              Icons.assignment,
                            color: seColor,
                            size: 35,
                          ),
                        ),
                        // assignment details
                        SizedBox(
                          width: 270,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // assignment name
                                if(assignmentResponse.assignmentName.length > 17)
                                Text(
                                    '${assignmentResponse.assignmentName.substring(0,17)}...',
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    color: seColor,
                                  ),
                                ),
                                if(assignmentResponse.assignmentName.length <= 15)
                                  Text(
                                    assignmentResponse.assignmentName,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: seColor,
                                    ),
                                  ),
                                // assignment Description
                                if(assignmentResponse.assignmentDescription.length >= 28)
                                  Text(
                                      '${assignmentResponse.assignmentDescription.substring(0,28)}....',
                                    style: const TextStyle(
                                      color: seColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                if(assignmentResponse.assignmentDescription.length < 28)
                                  Text(
                                    assignmentResponse.assignmentDescription,
                                    style: const TextStyle(
                                      color: txColor,
                                      fontSize: 15,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                            },
                            icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                            ),
                        ),
                      ],
                    ),
                     const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: 210,
                            child: Text(
                              'By :- ${assignmentResponse.creatorName}',
                              style: const TextStyle(
                                  color: seColor,
                                  fontWeight: FontWeight.w500
                              ),
                            )
                        ),
                        Text(
                            'Due date :- ${assignmentResponse.dueDate}',
                          style: const TextStyle(
                            color: seColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
