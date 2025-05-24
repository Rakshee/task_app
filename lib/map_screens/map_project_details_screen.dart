import 'package:flutter/material.dart';
class MapProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>  project;
  MapProjectDetailsScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project["name"])),
      body: Center(
        child: Text("Details of ${project["name"]}", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}