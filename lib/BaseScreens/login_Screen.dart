import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/apiServices/base_api_service.dart';
import 'package:assign_mate/colors.dart';
import 'package:assign_mate/BaseScreens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Uri _urlFB = Uri.parse("https://www.facebook.com/login/");
  final Uri _urlGoogle = Uri.parse(
      "https://accounts.google.com/v3/signin/identifier?continue"
          "=https%3A%2F%2Faccounts.google.com%2F&followup="
          "https%3A%2F%2Faccounts.google.com%2F&ifkv=Ab5oB3rLC82jZdK_"
          "Rn9ZIGx-Y0m6xw-E3pasF0vtI1ZmtvWmEVG1RQ82oqfe7teAXkQvmV7FiF0I"
          "bw&passive=1209600&flowName=GlifWebSignIn&flowEntry=Service"
          "Login&dsh=S287277681%3A1723466158471857&ddm=0");
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // this decoration for use white and red color combination using color gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red], // Start and end colors
            begin: Alignment.topLeft,            // Gradient start point
            end: Alignment.bottomRight,          // Gradient end point
          ),
        ),
        child: Scaffold(
          backgroundColor: prColor,
          body: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 500,
              width: 400,
              decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45)
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      // welcome text
                      const SizedBox(
                        child: Text(
                            'Welcome to',
                          style: TextStyle(
                            color: txColor,
                            fontSize: 29,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      // AssignMate Text
                      const SizedBox(
                        child: Text(
                          'AssignMate',
                          style: TextStyle(
                            color: txColor,
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ),
                      // phoneNumber TextFormField
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                        child: TextFormField(
                          controller: _phoneNumberController,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = RegExp(pattern);
                            if (value!.isEmpty) {
                              return "Enter Phone Number";
                            } else if(!regExp.hasMatch(value)){
                              return "Please enter valid number";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            hintStyle: const TextStyle(color: bgColor),
                            fillColor: Colors.black.withOpacity(0.2),
                            filled: true,
                            prefixIcon: const Icon(Icons.phone,color: txColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      // password TextFormField
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: TextFormField(
                          controller: _passwordController,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return "Please Enter Password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Your Password',
                            hintStyle: const TextStyle(
                                color: bgColor,
                            ),
                            fillColor: Colors.black.withOpacity(0.2),
                            filled: true,
                            prefixIcon: const Icon(
                                Icons.key,
                              color: txColor,
                            ),
                            suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon:
                                _isPasswordVisible
                                    ? const Icon(Icons.visibility_off,color: txColor)
                                    : const Icon(Icons.remove_red_eye_rounded,color: txColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: _isPasswordVisible,
                        ),
                      ),
                      // Login button
                      Padding(
                          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: SizedBox(
                          child: ElevatedButton(
                              onPressed: (){
                                if(_phoneNumberController.text.isEmpty ||
                                _passwordController.text.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please Enter Phone Number or password')));
                                }else{
                                  BaseApiService apiService = BaseApiService();
                                  apiService.loginApi(
                                      _phoneNumberController.text,
                                      _passwordController.text, context);
                                }
                              },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 50),
                              backgroundColor: prColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                              child: const Text(
                                  'Login',
                                style: TextStyle(
                                  color: txColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //signUp text and button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Create Account',
                          style: TextStyle(
                            color: txColor,
                            letterSpacing: 1,
                            fontSize: screenWidth * 0.033
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: IconButton(
                                icon: SizedBox(
                                  width: screenWidth * 0.06,
                                  child: Image.asset(
                                      'assets/images/google.png'),
                                ),
                                onPressed: () {
                                  launchUrl(_urlGoogle);
                                }
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            child: IconButton(
                              icon: Icon(
                                Icons.facebook, color: Colors.blue, size: screenWidth * 0.08,),
                              onPressed: () {
                                launchUrl(_urlFB);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

    );
  }
}
