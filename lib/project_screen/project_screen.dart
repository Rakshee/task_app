import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_apps/constants/color.dart';
import 'package:first_apps/map_screens/map_screen.dart';
import 'package:first_apps/media_screen/media_screen.dart';
import 'package:flutter/material.dart';
import '../charts_screen/charts_screen.dart';
import '../login_screen.dart';
import 'project_detail_screen.dart';
import '../project_screen_model/project_model.dart';

class ProjectListScreen extends StatefulWidget {
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final TextEditingController searchCtrl = TextEditingController();

  List<Project> allProjects = [
    Project(
      id: '1',
      name: 'View Magic of Space',
      images: ['assets/space1.jpg', 'assets/space2.jpg', 'assets/space3.jpg'],
      videos: ['assets/space4.mp4'],
    ),
    Project(
      id: '2',
      name: 'Greenfield Housing',
      images: ['assets/recipe1.jpg'],
      videos: ['assets/recipe2.mp4'],
    ),
    Project(
      id: '3',
      name: 'Fitness Tracker',
      images: ['assets/fitness1.jpg'],
      videos: ['assets/fitness2.mp4'],
    ),
  ];

  List<Project> displayedProjects = [];

  @override
  void initState() {
    super.initState();
    displayedProjects = allProjects;
  }

  void searchProjects(String query) {
    final results = allProjects
        .where(
          (project) => project.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    setState(() => displayedProjects = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Projects"))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow[800]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 64, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outlined),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.perm_media_outlined),
              title: Text('Media Screen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MediaScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('Map Screen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapScreen()),
                );

              },
            ),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('Chart Screen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChartsScreen()),
                );

              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              cursorColor: colorPrimary,
              controller: searchCtrl,
              decoration: InputDecoration(
                labelText: "Search Projects",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchProjects,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedProjects.length,
              itemBuilder: (context, index) {
                final project = displayedProjects[index];
                return ListTile(
                  title: Text(project.name),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailScreen(project: project),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }



}
