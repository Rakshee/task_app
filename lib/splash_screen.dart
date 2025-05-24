import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_apps/constants/color.dart';
import 'package:first_apps/project_screen/project_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimary,
      body: FutureBuilder<User?>(
        future: Future.delayed(
          Duration(seconds: 2),
          () => FirebaseAuth.instance.currentUser,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flash_on, size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    "Projex360",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 40),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.data != null) {
              return ProjectListScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }
}
