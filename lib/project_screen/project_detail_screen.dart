import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../media_screen/video_player_screen.dart';
import '../project_screen_model/project_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  ProjectDetailScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Images and Videos
      child: Scaffold(
        appBar: AppBar(
          title: Text(project.name),

          bottom: TabBar(
            labelColor: Colors.white,            // Selected tab color
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Images", icon: Icon(Icons.image)),
              Tab(text: "Videos", icon: Icon(Icons.video_library)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Images Tab
            GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: project.images.length,
              itemBuilder: (context, index) {
                return Image.asset(project.images[index], fit: BoxFit.cover);
              },
            ),

            // Videos Tab
            ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: project.videos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.play_circle_fill),
                    title: Text("Video ${index + 1}"),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => VideoPlayerScreen(videoUrl: ""),
                      //   ),
                      // );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Video tapped")),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
