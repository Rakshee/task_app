import 'dart:io';
import 'package:first_apps/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MediaScreen extends StatefulWidget {
  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late Future<List<String>> mediaFuture;

  @override
  void initState() {
    super.initState();
    mediaFuture = fetchMediaUrls();
  }

  Future<void> uploadMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Upload Image'),
            onTap: () {
              Navigator.pop(context);
              uploadImage();
            },
          ),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('Upload Video'),
            onTap: () {
              Navigator.pop(context);
              uploadVideo();
            },
          ),
        ],
      ),
    );
  }

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = FirebaseStorage.instance.ref().child('media/$fileName');

    try {
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putData(bytes, metadata); // no await here
      final snapshot = await uploadTask; // await upload completion
      final url = await snapshot.ref.getDownloadURL();
      print('Image uploaded: $url');

      setState(() {
        mediaFuture = fetchMediaUrls();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully')),
      );
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed')),
      );
    }
  }

  Future<void> uploadVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final ref = FirebaseStorage.instance.ref().child('media/$fileName');

    try {
      final metadata = SettableMetadata(contentType: 'video/mp4');
      final uploadTask = ref.putFile(file, metadata); // no await here
      final snapshot = await uploadTask; // await upload completion
      final url = await snapshot.ref.getDownloadURL();
      print('Video uploaded: $url');

      setState(() {
        mediaFuture = fetchMediaUrls();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully')),
      );
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video upload failed')),
      );
    }
  }

  Future<List<String>> fetchMediaUrls() async {
    ListResult result = await FirebaseStorage.instance.ref('media').listAll();
    List<String> urls = [];

    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  Future<void> downloadMedia(String url, String fileName) async {
    if (await Permission.storage.request().isGranted) {
      final response = await http.get(Uri.parse(url));
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Media Manager')),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadMedia,
        child: Icon(Icons.upload, color: colorPrimary),
      ),
      body: FutureBuilder<List<String>>(
        future: mediaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading media'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No media available'));
          }

          final mediaUrls = snapshot.data!;
          return ListView.builder(
            itemCount: mediaUrls.length,
            itemBuilder: (context, index) {
              final url = mediaUrls[index];
              final fileName = url.split('%2F').last.split('?').first;

              return Card(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: MediaViewer(url: url),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(fileName),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.download, color: colorPrimary),
                      label: Text('Download'),
                      onPressed: () => downloadMedia(url, fileName),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MediaViewer extends StatefulWidget {
  final String url;
  const MediaViewer({required this.url});

  @override
  _MediaViewerState createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.url.endsWith('.mp4')) {
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {
            _chewieController = ChewieController(
              videoPlayerController: _videoController!,
              autoPlay: false,
              looping: false,
            );
          });
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.endsWith('.mp4')) {
      return _chewieController != null
          ? Chewie(controller: _chewieController!)
          : Center(child: CircularProgressIndicator());
    } else {
      return Image.network(widget.url, fit: BoxFit.cover);
    }
  }
}
