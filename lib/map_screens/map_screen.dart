import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_project_details_screen.dart';


class MapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> projects = [
    {"name": "Project A", "location": LatLng(20.2961, 85.8245)},
    {"name": "Project B", "location": LatLng(19.0760, 72.8777)},
    {"name": "Project C", "location": LatLng(28.7041, 77.1025)},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Projects Map')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(19.5, 76.0),
          initialZoom: 6.0,
        ),
        children: [

          TileLayer(
            urlTemplate:
            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: projects.map((project) {
              return Marker(
                point: project["location"],
                width: 40.0,
                height: 40.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapProjectDetailsScreen(project:project),
                      ),
                    );
                  },
                  child: Icon(Icons.location_on, color: Colors.red, size: 30),
                ),
              );
            }).toList(),
          ),
        ],

      ),
    );
  }
}
