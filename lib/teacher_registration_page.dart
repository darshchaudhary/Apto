import 'package:apto/student_landing_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apto/student_login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'curves.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'teacher_login_page.dart';
import 'teacher_landing_page.dart';
import 'package:email_auth/email_auth.dart';
import 'email_verification.dart';

class TeacherRegistrationPage extends StatefulWidget {
  @override
  _TeacherRegistrationPageState createState() =>
      _TeacherRegistrationPageState();
}

class _TeacherRegistrationPageState extends State<TeacherRegistrationPage> {
  TextEditingController otpEmail = TextEditingController();
  TextEditingController otp = TextEditingController();
  EmailOTP myauth = EmailOTP();
  String? inputEmail;

  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String? dropDownValue;
  String? firstName, password, email, lastName;
  String _errorMessage = '';
  bool hasError = false;

  bool _validatePassword(String password) {
    if (password.length < 8) {
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
              ),
            ),
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
                        'Teacher Registration',
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
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'FirstName', border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  hasError = true;
                                });
                                return 'Please enter a username';
                              }
                              if (value.contains(
                                  RegExp(r'[!@#%^&*(),?":{}|<>~$]'))) {
                                setState(() {
                                  hasError = true;
                                });
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
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: 'Last Name', border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  hasError = true;
                                });
                                return 'Please enter a name';
                              }
                              if (value.contains(
                                  RegExp(r'[!@#%^&*(),?":{}|<>~$_.1234567890]'))) {
                                setState(() {
                                  hasError = true;
                                });
                                return 'Only letters allowed for names';
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
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email ID', border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  hasError = true;
                                });
                                return 'Please enter an email';
                              }
                              if (!EmailValidator.validate(value)) {
                                setState(() {
                                  hasError = true;
                                });
                                return 'Please enter a valid email';
                              } else {
                                setState(() {
                                  inputEmail = value;
                                });
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
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
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
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
                                password = value;
                                setState(() {
                                  _errorMessage = '';
                                });
                              },
                            ),
                          ),
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
                                  final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email.toString(),
                                      password: password.toString());
                                  if (newUser != null) {
                                    _fireStore.collection('teacher').add(
                                      {
                                        'firstName': firstName.toString(),
                                        'lastName': lastName.toString(),
                                        'email': _auth.currentUser?.email,
                                      },
                                    );
                                    myauth.setConfig(
                                      appEmail: "darshc2007@gmail.com",
                                      appName: "Email OTP",
                                      userEmail: inputEmail!,
                                      otpLength: 6,
                                      otpType: OTPType.digitsOnly,
                                    );
                                    if (await myauth.sendOTP() == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OTPVerificationPage(
                                            inputEmail: inputEmail!,
                                            firstName: firstName!,
                                            lastName: lastName!,
                                            emailAuth: myauth,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Oops, OTP send failed"),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                                setState(() {
                                  showSpinner = false;
                                });

                                print(
                                    'Name: $firstName, Password: $password, Email: $email');
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherLoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF004A81),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}


