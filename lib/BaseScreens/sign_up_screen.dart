import 'package:assign_mate/apiServices/base_api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors.dart';
import 'login_Screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final Uri _urlFB = Uri.parse("https://www.facebook.com/login/");
  final Uri _urlGoogle = Uri.parse(
      "https://accounts.google.com/v3/signin/identifier?continue=https%3A%2F%2"
      "Faccounts.google.com%2F&followup=https%3A%2F%2Faccounts.google.com%2F&ifk"
      "v=Ab5oB3rLC82jZdK_Rn9ZIGx-Y0m6xw-E3pasF0vtI1ZmtvWmEVG1RQ82oqfe7teAXkQvmV7FiF0Ibw&passive"
      "=1209600&flowName=GlifWebSignIn&flowEntry=ServiceLogin&dsh=S287277681%3A1723466158471857&ddm=0");
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  String? _selectedRole = 'user';
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // this decoration for use white and red color combination using color gradient
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.red], // Start and end colors
          begin: Alignment.topLeft, // Gradient start point
          end: Alignment.bottomRight, // Gradient end point
        ),
      ),
      child: Scaffold(
        backgroundColor: prColor,
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 700,
            width: 400,
            decoration: const BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45)),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    // Create text
                    const SizedBox(
                      child: Text(
                        'Create Account on',
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
                    // userName TextFormField
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 40, left: 15, right: 15),
                      child: TextFormField(
                        controller: _userNameController,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please Enter name";
                          }else if(value.length < 5){
                            return 'Please Enter valid name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
                          hintStyle: const TextStyle(color: bgColor),
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          prefixIcon: const Icon(Icons.person,color: txColor,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    // phoneNumber TextFormField
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                          hintText: 'Enter PhoneNumber',
                          hintStyle: const TextStyle(color: bgColor),
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          prefixIcon: const Icon(Icons.phone,color: txColor,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    // password TextFormField
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        keyboardType: TextInputType.visiblePassword,
                         validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Enter password';
                          }
                          return null;
                         },
                        decoration: InputDecoration(
                          hintText: 'Create Password',
                          hintStyle: const TextStyle(
                            color: bgColor,
                          ),
                          fillColor: Colors.black.withOpacity(0.2),
                          filled: true,
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: _isPasswordVisible
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
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                              'Sign Up as',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: txColor,
                            ),
                          ),
                        )
                    ),

                    // role radia button
                    RadioListTile<String>(
                        title: const Text('User'),
                        value: 'user',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        }
                    ),
                    RadioListTile<String>(
                        title: Text('Admin'),
                        value: 'admin',
                        groupValue: _selectedRole,
                        onChanged: (value){
                          setState(() {
                            _selectedRole = value;
                          });
                        }
                    ),
                    if(_selectedRole == "admin")
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: TextFormField(
                          controller: _codeController,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please Enter code';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Code',
                            hintStyle: const TextStyle(color: bgColor),
                            fillColor: Colors.black.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                    // Sign Up button
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            if(!textFieldValidation()){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill Everything')));
                            }else{
                              BaseApiService apiService = BaseApiService();
                              if(_selectedRole == 'admin'){
                                if(_codeController.text == 'codingAge1'){
                                  final res = apiService.signUpApi(
                                      _userNameController.text,
                                      _phoneNumberController.text,
                                      _passwordController.text,
                                      _selectedRole!, context);
                                  print(res);
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Wrong Code')));
                                }
                              }
                              else{
                                final res = apiService.signUpApi(
                                    _userNameController.text,
                                    _phoneNumberController.text,
                                    _passwordController.text,
                                    _selectedRole!, context);
                                print(res);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              }
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 50),
                            backgroundColor: prColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
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
                    // login text
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                        letterSpacing: 2,
                      )),
                      child: const Text(
                        'i have an account? Log In',
                        style: TextStyle(
                          color: txColor,
                        ),
                      ),
                    ),
                    // google facebook login icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: IconButton(
                              icon: SizedBox(
                                width: 24,
                                height: 24,
                                child: Image.asset('assets/images/google.png'),
                              ),
                              onPressed: () {
                                launchUrl(_urlGoogle);
                              }),
                        ),
                        SizedBox(
                          child: IconButton(
                            icon: const Icon(
                              Icons.facebook,
                              color: Colors.blue,
                              size: 30,
                            ),
                            onPressed: () {
                              launchUrl(_urlFB);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool textFieldValidation(){
    if(_selectedRole == "admin"){
      if(_userNameController.text.isEmpty ||
          _phoneNumberController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _codeController.text.isEmpty){
        return false;
      }else{
        return true;
      }
    }else{
      if(_userNameController.text.isEmpty ||
          _phoneNumberController.text.isEmpty ||
          _passwordController.text.isEmpty){
        return false;
      }else{
        return true;
      }
    }
  }
}
