import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapplication/provider/task_provider.dart';
import 'package:todoapplication/screens/Login_Screen.dart';


import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(), // Apply Montserrat text theme
        tabBarTheme: TabBarTheme( // Proper TabBarTheme object
          labelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.montserrat(),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
