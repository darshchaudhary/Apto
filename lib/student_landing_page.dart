import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudentLandingPage extends StatefulWidget {
  StudentLandingPage({this.transferName, this.transferClass});
  String? transferName;
  String? transferClass;

  @override
  State<StudentLandingPage> createState() => _StudentLandingPageState();
}

class _StudentLandingPageState extends State<StudentLandingPage> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User? loggedInUser;

  String? displayName;
  String? displayEmail;
  String? displayClass;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);

        // Fetch teacher data from Firestore based on the logged-in user's email
        final teacherQuery = await _fireStore.collection('student').where('email', isEqualTo: loggedInUser?.email).get();
        if (teacherQuery.docs.isNotEmpty) {
          final studentData = teacherQuery.docs.first.data();
          setState(() {
            displayEmail = loggedInUser?.email;
            displayName = '${studentData['firstName']} ${studentData['lastName']}';
            displayClass = studentData['grade'];
          });
        }

        final teacherUser = await _fireStore.collection('teacher').get(GetOptions(source: Source.serverAndCache));
        print(teacherUser.docs);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Color(0xFF454197),
                    child: Center(
                      child: Text(
                        'APTO',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 120,
                            fontFamily: 'SansitaOne',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey.shade500,
                              offset: Offset(0, 2))
                        ]),
                    margin: EdgeInsets.fromLTRB(30, 150, 30, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName.toString(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          displayEmail.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${displayClass.toString()}th Grade',
                          style: TextStyle(fontSize: 18),
                        ),
                        Divider(
                          height: 2.0,
                          color: Colors.grey.shade600,
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                _auth.signOut();
                                Navigator.pushNamed(context, 'welcome');
                              },
                              child: (Text(
                                'Sign Out',
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFF454197)),
                              ))),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: LandingButton(
                    buttonText: 'Take Aptitude Test',
                    buttonTap: () {
                      Navigator.pushNamed(context, 'testing');
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: LandingButton(
                    buttonText: 'See Past Tests',
                    buttonTap: () {
                      Navigator.pushNamed(context, 'pastTests');
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class LandingButton extends StatelessWidget {
  LandingButton({required this.buttonText, required this.buttonTap});

  String buttonText;
  void Function() buttonTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  color: Colors.grey.shade500,
                  offset: Offset(0, 2))
            ]),
        margin: EdgeInsets.all(30),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}






