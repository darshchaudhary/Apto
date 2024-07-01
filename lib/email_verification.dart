import 'package:flutter/material.dart';
import 'curves.dart';
import 'package:email_otp/email_otp.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'teacher_landing_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final String inputEmail;
  final String firstName;
  final String lastName;
  final EmailOTP emailAuth;

  const OTPVerificationPage({
    Key? key,
    required this.inputEmail,
    required this.firstName,
    required this.lastName,
    required this.emailAuth
  }) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController otpController = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'An OTP has been sent to ${widget.inputEmail}',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if (await widget.emailAuth.verifyOTP(otp: otpController.text)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherLandingPage(
                          transferFName: widget.firstName,
                          transferLName: widget.lastName,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid OTP! Please try again.'),
                      ),
                    );
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
