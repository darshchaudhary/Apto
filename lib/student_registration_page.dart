
import 'package:apto/student_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:apto/student_login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'curves.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudentRegistrationPage extends StatefulWidget {
  @override
  _StudentRegistrationPageState createState() => _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {

  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String? dropDownValue;
  String? firstName, password, email, lastName;
  String _errorMessage = '';
  bool _validatePassword(String password) {

    if (password.length <8) {
      _errorMessage += 'Password must be longer than 8 characters.\n';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
    }
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>_]'))) {
      _errorMessage += '• Special character is missing.\n';
    }
    // If there are no error messages, the password is valid
    return _errorMessage.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Color(0xFF004A81),
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Hero(
                  tag: 'topCurve',
                  child: ClipPath(
                    clipper: TopCurve(),
                    child: Container(
                      color: Color(0xFF004A81),
                    ),
                  ),
                )),
            Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Student Registration',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey.shade300,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'FirstName',
                                border: InputBorder.none
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (value.contains(RegExp(r'[!@#%^&*(),?":{}|<>~$]'))) {
                                  return 'Only \'_\' and \'.\' allowed for names';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                firstName = value.toString();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey.shade300,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  border: InputBorder.none
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (value.contains(RegExp(r'[!@#%^&*(),?":{}|<>~$]'))) {
                                  return 'Only \'_\' and \'.\' allowed for names';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                lastName = value.toString();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey.shade300,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: 'Email ID',
                                  border: InputBorder.none
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!EmailValidator.validate(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onChanged: (value) => email = value,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.grey.shade300,
                                  offset: Offset(0, 2)
                                )
                              ]
                            ),
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (!_validatePassword(value)) {
                                  return _errorMessage;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  password = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.grey.shade300,
                                      offset: Offset(0, 2)
                                  )
                                ]
                            ),
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                  color: Colors.black
                                ),
                                //padding: EdgeInsets.all(15),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Select Grade',
                                ),
                                value: dropDownValue,
                                onChanged: (String? _value) {
                                  setState(() {
                                    dropDownValue = _value;
                                  });
                                  print(dropDownValue);
                                },
                                items: gradeList
                              ),
                            )
                          ),
                        ),

                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    final newUser = await _auth.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
                                    if (newUser != null) {
                                      _fireStore.collection('student').add(
                                          {
                                            'firstName': firstName.toString(),
                                            'lastName': lastName.toString(),
                                            'grade': dropDownValue,
                                            'email': _auth.currentUser?.email,
                                            'reports': 0
                                          }
                                      );
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentLandingPage(
                                        transferName: firstName,
                                        transferClass: dropDownValue,
                                      )));
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch(e) {
                                    print(e);
                                  }
                                  print('Name: $firstName, Password: $password, Email: $email');
                                }
                              },
                              child: Text('Register'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF004A81),
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(15),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StudentLoginPage()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Color(0xFF004A81), fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                ),
            Expanded(
                flex: 1,
                child: Hero(
                  tag: 'bottomCurve',
                  child: ClipPath(
                    clipper: BottomCurve(),
                    child: Container(
                      color: Color(0xFF2F6E92),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
