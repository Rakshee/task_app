import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_apps/project_screen/project_screen.dart';
import 'package:first_apps/register_screen.dart';
import 'package:first_apps/forget_password.dart';
import 'package:flutter/material.dart';

import 'constants/color.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pswdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome\nPlease Login Here',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow.shade800,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              TextField(
                controller: emailCtrl,
                cursorColor: Colors.yellow[700],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Email",
                  hintText: "Enter your email",
                ),
              ),

              SizedBox(height: 20),

              TextField(
                controller: pswdCtrl,
                cursorColor: Colors.yellow[700],
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Password",
                  hintText: "Enter your password",
                ),
              ),

              SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: colorPrimary),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String mail = emailCtrl.text.trim();
                    String pswd = pswdCtrl.text.trim();

                    if (mail.isEmpty || pswd.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter all fields")),
                      );
                    } else {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: mail,
                            password: pswd,
                          )
                          .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login successful")),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectListScreen(),
                              ),
                            );
                          })
                          .catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.message ?? "Login failed"),
                              ),
                            );
                          });
                    }
                  },
                  child: Text("Login"),
                ),
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('''Don't have an account ? '''),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: colorPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
