import 'package:apto/student_landing_page.dart';
import 'package:apto/student_login_page.dart';
import 'package:apto/past_tests.dart';
import 'package:apto/student_registration_page.dart';
import 'package:apto/splash_screen.dart';
import 'package:apto/teacher_landing_page.dart';
import 'package:apto/teacher_registration_page.dart';
import 'package:apto/testing_page.dart';
import 'package:apto/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(

            initialRoute: 'welcome',
            routes: {
              'welcome': (context) => WelcomePage(),
              'registration': (context) => StudentRegistrationPage(),
              'login': (context) => StudentLoginPage(),
              'studLanding': (context) => StudentLandingPage(),
              'pastTests': (context) => PastTestsPage(),
              'testing': (context) => TestingPage(),
              'teachLanding': (context) => TeacherLandingPage(),
              'teachRegister': (context) => TeacherRegistrationPage()
            },
            home: WelcomePage(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return SplashScreen();
      },
    );
  }
}


