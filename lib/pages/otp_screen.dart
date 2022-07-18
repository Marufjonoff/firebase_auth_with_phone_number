import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authenticate/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key? key, this.phoneNumber}) : super(key: key);

  String? phoneNumber;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String code = "123456";
  TextEditingController pinPutController = TextEditingController();

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+${widget.phoneNumber}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((
            value) =>
        {
          if(value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false)
                    }
        });
      },
      verificationFailed: (FirebaseAuthException exception) {
        log(exception.message.toString());
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          if(mounted) {
            code = verificationID;
          }
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          if(mounted) {
            code = verificationID;
          }
        });
      },
      timeout: const Duration(seconds: 30),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verifyPhoneNumber();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("OTP Verification"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Phone number ${widget.phoneNumber}"),

            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Pinput(
                controller: pinPutController,
                length: 6,
                showCursor: true,
                onCompleted: (pin) => print(pin),
                onSubmitted: (String submit) async {
                  try {
                    await FirebaseAuth.instance.signInWithCredential(
                        PhoneAuthProvider.credential(
                            verificationId: code,
                            smsCode: submit
                        )
                    ).then((value) => {
                      if(value.user != null) {
                        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => const HomePage()), (route) => false)
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    scaffoldKey.currentState?.showSnackBar(const SnackBar(content: Text("Invalid otp")));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
