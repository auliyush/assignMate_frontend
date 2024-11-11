import 'package:assign_mate/BaseScreens/login_Screen.dart';
import 'package:assign_mate/Screens/notification_screen.dart';
import 'package:assign_mate/colors.dart';
import 'package:assign_mate/submission/submissions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/user_provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}
class _MoreScreenState extends State<MoreScreen> {
  String userName = 'Saumya kumari';
  String mobNno = "8969583031";
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // user details container
          Container(
            height: screenHeight * 0.27,
            width: screenWidth,
            color: prColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      // circleAvatar
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.06, top: screenHeight * 0.05),
                        child: Container(
                          width: screenWidth * 0.26,
                          child: CircleAvatar(
                            backgroundColor: seColor,
                            radius: screenWidth * 0.13,
                            child: Text(
                              'A',
                              style: TextStyle(fontSize: screenWidth * 0.07),
                            ),
                          ),
                        ),
                      ),
                    // notification
                    Container(
                      padding: EdgeInsets.only(right: screenWidth * 0.05),
                      child: IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                          },
                          icon: Icon(
                              Icons.notifications,
                            size: screenWidth * 0.09,
                            color: txColor,
                            shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 4.0,
                                color: Colors.black12, // Soft shadow
                              ),
                            ],
                          ),
                      ),
                    )
                  ],
                ),
                // userName
                Padding(
                  padding: EdgeInsets.only(left : screenWidth * 0.03, top: screenWidth * 0.03),
                  child: Container(
                    child: Text(
                      Provider.of<UserProvider>(context, listen: false).userResponse!.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2, // Slightly increased letter spacing
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black26, // Soft shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // number
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03),
                  child: Container(
                    child: Text(
                      Provider.of<UserProvider>(context, listen: false).userResponse!.phoneNumber,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.black26, // Soft shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.6,
            width: screenWidth,
            child: Column(
              children: [
                _buildCard(
                    title: 'My Submissions',
                    icon: Icons.edit_note_rounded,
                    onTap: (){
                      // todo check here validation is wrong
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context) => SubmissionsScreen()));
                    },
                  context: context,
                ),
                _buildCard(
                    title: 'Log-out',
                    icon: Icons.logout,
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                    },
                    context: context
                ),
                ],
            ),
          ),
        ],
      )
    );
  }
  Widget _buildCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 7,bottom: 7),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white54,
                child: Icon(
                  icon,
                  size: 30,
                ),
              ),
               SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    color: seColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.06),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: txColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
