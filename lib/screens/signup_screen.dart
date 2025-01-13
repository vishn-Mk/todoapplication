
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../services/authentication.dart';
import '../widget/custom_textfield.dart';
import '../widget/snackbar.dart';
import 'Home_Screen.dart';
import 'Login_Screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  // Firebase Store - Sign Up Function
  void signUpUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Perform signup
      String res = await AuthServices().signUpUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      // If sign-up is successful
      if (res == "Success") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Show error message using snackbar
        showSnackBar(context, res);
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
        children: [
          // Background SVG
          SizedBox(height: 60,),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: SvgPicture.asset(
              'asset/icons/signup.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Sign Up Form
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Welcome Text
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,

                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Let's Create Account Together",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Name Field
                        custom_textfeild(
                          controller: nameController,
                          labeltext: 'Name',

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Email Field
                        custom_textfeild(
                          controller: emailController,
                          labeltext: 'Email Address',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Password Field
                        custom_textfeild(
                          controller: passwordController,
                          labeltext: 'Password',
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Sign Up Button
                        ElevatedButton(
                          onPressed: signUpUser,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Sign Up with Google Button
                        ElevatedButton.icon(
                          onPressed: () {
                            // Google sign-up logic goes here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide.none,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          icon: Image.asset(
                            'asset/images/google-logo-9808.png',
                            height: 24,
                          ),
                          label: Text(
                            'Sign up with Google',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
