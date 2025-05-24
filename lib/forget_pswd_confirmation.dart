import 'package:flutter/material.dart';

class ForgotPasswordConfirmation extends StatelessWidget {
  final String email;

  ForgotPasswordConfirmation({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email Sent")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 100, color: Colors.black54),
              SizedBox(height: 30),
              Text(
                "A password reset link has been sent to",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                email,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text("Back to Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
