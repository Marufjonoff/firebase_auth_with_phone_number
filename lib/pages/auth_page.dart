import 'package:firebase_authenticate/pages/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Number"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Phone number verification"),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey.shade300,
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Phone number",
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => OTPScreen(phoneNumber: controller.text.trim(),)));
            },
            minWidth: 200,
            height: 50,
            color: Colors.blue,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Text("Next"),
          )
        ],
      ),
    );
  }
}
