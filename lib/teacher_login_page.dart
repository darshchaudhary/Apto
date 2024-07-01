import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'curves.dart';

class TeacherLoginPage extends StatefulWidget {
  @override
  _TeacherLoginPageState createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? password, email;
  bool showPassword = false;

  void _showEmailErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Incorrect Email/Password'),
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
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Incorrect Email/Password'),
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
                        'Teacher Login',
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
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
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
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
                              setState(() {
                                showSpinner = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await _auth.signInWithEmailAndPassword(
                                    email: email.toString(),
                                    password: password.toString(),
                                  );
                                  Navigator.pushNamed(context, 'teachLanding');
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found' ||
                                      e.code == 'wrong-password') {
                                    _showEmailErrorDialog();
                                  }
                                } catch (e) {
                                  _showErrorDialog();
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            },
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC01802),
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
                              Navigator.pushNamed(context, 'registration');
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFFC01802),
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
