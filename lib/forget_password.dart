import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_apps/constants/color.dart';
import 'package:flutter/material.dart';
import 'forget_pswd_confirmation.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  bool isLoading = false;

  void sendResetEmail() async {
    String email = emailCtrl.text.trim();

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text("Please enter your email."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() => isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordConfirmation(email: email),
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your email to receive a password reset link",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailCtrl,
              cursorColor: colorPrimary,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: sendResetEmail,
              child: Text("Send Reset Email"),
            ),
          ],
        ),
      ),
    );
  }
}
