import 'package:flutter/material.dart';
import 'package:apto/student_login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'curves.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? password, email;
  String _errorMessage = '';

  bool _validatePassword(String password) {
    _errorMessage = '';
    if (password.length < 8) {
      _errorMessage += 'Password must be longer than 8 characters.\n';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += 'Uppercase letter is missing.\n';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      _errorMessage += 'Lowercase letter is missing.\n';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += 'Digit is missing.\n';
    }
    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>_]'))) {
      _errorMessage += 'Special character is missing.\n';
    }
    return _errorMessage.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Color(0xFFC01802),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Hero(
                tag: 'topCurve',
                child: ClipPath(
                  clipper: TopCurve(),
                  child: Container(
                    color: Color(0xFFC01802),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Student Login',
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
                                  offset: Offset(0, 2))
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              } else if (!EmailValidator.validate(value)) {
                                return 'Enter a valid email';
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
                                  offset: Offset(0, 2))
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              } else if (!_validatePassword(value)) {
                                return _errorMessage;
                              }
                              return null;
                            },
                            onChanged: (value) => password = value,
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
                                  await _auth.signInWithEmailAndPassword(
                                    email: email!,
                                    password: password!,
                                  );
                                  Navigator.pushNamed(context, 'studLanding');
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found' ||
                                      e.code == 'wrong-password') {
                                    _showErrorDialog('Incorrect Email/Password');
                                  }
                                } catch (e) {
                                  _showErrorDialog('An error occurred. Please try again.');
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC01802),
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
                              Navigator.pushNamed(context, 'registration');
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Color(0xFFC01802), fontSize: 16),
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
              flex: 2,
              child: Hero(
                tag: 'bottomCurve',
                child: ClipPath(
                  clipper: BottomCurve(),
                  child: Container(
                    color: Color(0xFFE34807),
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
