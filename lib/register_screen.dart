import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants/color.dart';
import 'login_screen.dart';

class Register extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pswdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please register below',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 40),

              TextField(
                controller: emailCtrl,
                cursorColor: Colors.yellow[800],
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  prefixIcon: Icon(Icons.email, color: Colors.yellow[800]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),

              TextField(
                controller: pswdCtrl,
                obscureText: true,
                cursorColor: Colors.yellow[800],
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.yellow[800]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String mail = emailCtrl.text.trim();
                    String pswd = pswdCtrl.text.trim();

                    if (mail.isEmpty || pswd.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Enter all the fields")),
                      );
                    } else {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(email: mail, password: pswd);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registered successfully")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registration failed")),
                        );
                      }
                    }
                  },
                  child: Text("Register"),
                ),
              ),
              SizedBox(height: 30),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('''Already have an account ? '''),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  LoginScreen()));
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(color: colorPrimary, fontSize: 16, fontWeight: FontWeight.bold,),
                      )),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
