
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todoapplication/screens/signup_screen.dart';


import '../services/authentication.dart';
import '../services/google_auth.dart';
import '../widget/custom_textfield.dart';
import '../widget/snackbar.dart';
import 'home_screen.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }



  void setFirebaseLanguage() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Set the language code dynamically based on the device's locale
    final String systemLocale = window.locale.languageCode;
    auth.setLanguageCode(systemLocale);
  }


  void loginUsers() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Set the Firebase Auth locale
        auth.setLanguageCode('en'); // Replace 'en' with your desired language code

        // Perform login
        String res = await AuthServices().loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        setState(() {
          isLoading = false;
        });

        if (res == "Success") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          showSnackBar(context, res);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "An unexpected error occurred: $e");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Background SVG
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SvgPicture.asset(
              'asset/icons/login.svg', // Update to your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Login Form
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        custom_textfeild(
                          controller: emailController,
                          labeltext: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        custom_textfeild(
                          controller: passwordController,
                          labeltext: "Password",
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: loginUsers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  height: 1, color: Colors.black26),
                            ),
                            const Text("  or  "),
                            Expanded(
                              child: Container(
                                  height: 1, color: Colors.black26),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await FirebaseServices().signInWithGoogle();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 15),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          icon: Image.asset(
                              'asset/images/google-logo-9808.png',
                              height: 24),
                          label: const Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     myDialogBox(context);
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.green,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     padding:
                        //     const EdgeInsets.symmetric(vertical: 15),
                        //     minimumSize: const Size(double.infinity, 50),
                        //   ),
                        //   icon: Image.asset('asset/images/phone.png',
                        //       height: 24),
                        //   label: const Text(
                        //     'Sign in with Phone',
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't Have An Account?",
                              style:
                              TextStyle(color: Color(0xFF707B81)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const SignUp(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
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
