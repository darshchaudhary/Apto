import 'package:apto/student_login_page.dart';
import 'package:apto/student_registration_page.dart';
import 'package:apto/teacher_registration_page.dart';
import 'package:flutter/material.dart';
import 'curves.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Hero(
                tag: 'topCurve',
                child: ClipPath(
                  clipper: TopCurve(),
                  child: Container(
                    color: Color(0xFF00570C),
                    margin: EdgeInsets.only(bottom: 30),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 25),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherRegistrationPage()));
                    },
                    child: Text(
                      'Teacher',
                      style: TextStyle(
                          color: Colors.black,
                        fontSize: 20
                      ),
                    ),
                    style: ButtonStyle(
                        elevation: MaterialStatePropertyAll(3),
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)
                            )
                        )
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 25, 15, 22.5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentRegistrationPage()));
                    },
                    child: Text(
                      'Student',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(3),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)
                        )
                      )
                    ),
                  ),
                ),
              )
            ],
          )),
          Expanded(
              flex: 2,
              child: Hero(
                tag: 'bottomCurve',
                child: ClipPath(
                  clipper: BottomCurve(),
                  child: Container(
            color: Color(0xFF103919),
            margin: EdgeInsets.only(top: 30),
          ),
                ),
              )),
        ],
      ),
    );
  }
}











