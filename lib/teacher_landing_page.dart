import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherLandingPage extends StatefulWidget {
  TeacherLandingPage({this.transferFName, this.transferLName});
  String? transferLName;
  String? transferFName;

  @override
  State<TeacherLandingPage> createState() => _TeacherLandingPageState();
}

class _TeacherLandingPageState extends State<TeacherLandingPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  String? displayFName;
  String? displayLName;
  String? displayEmail;

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
        final teacherQuery = await _fireStore.collection('teacher').where('email', isEqualTo: loggedInUser?.email).get();
        if (teacherQuery.docs.isNotEmpty) {
          final teacherData = teacherQuery.docs.first.data();
          setState(() {
            displayEmail = loggedInUser?.email;
            displayFName = teacherData['firstName'];
            displayLName = teacherData['lastName'];
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
                    )
                )
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
                          '$displayFName $displayLName',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          displayEmail.toString(),
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
                  flex: 2,
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _fireStore.collection('student').snapshots(),
                      builder: (context, snapshot){
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final students = snapshot.data?.docs;
                        List<Container> studentInfo = [];
                        for (var student in students!) {
                          final studFirstName = student.get('firstName');
                          final studLastName = student.get('lastName');
                          final studGrade = student.get('grade');

                          final studentWidget = Container(
                            decoration: BoxDecoration(
                                border: BorderDirectional(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade300
                                    )
                                )
                            ),
                            padding: EdgeInsets.all(15),
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${studFirstName} ${studLastName}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  '${studGrade}th Grade',
                                  style: TextStyle(
                                      fontSize: 15
                                  ),
                                )
                              ],
                            ),
                          );
                          studentInfo.add(studentWidget);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: studentInfo,
                        );
                      },
                    ),
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





