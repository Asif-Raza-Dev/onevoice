import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio File Selector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AudioFileSelectorScreen(),
    );
  }
}

class AudioFileSelectorScreen extends StatefulWidget {
  const AudioFileSelectorScreen({super.key});

  @override
  State<AudioFileSelectorScreen> createState() => _AudioFileSelectorScreenState();
}

class _AudioFileSelectorScreenState extends State<AudioFileSelectorScreen> {
  List<Map<String, dynamic>> _audioFiles = [];

  Future<void> _selectAudioFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        if (kIsWeb) {
          // For web, use the bytes property
          if (file.bytes != null) {
            _audioFiles.add({
              'name': file.name,
              'duration': 'Duration not available on web', // Duration cannot be fetched on web
            });
          }
        } else {
          // For mobile/desktop, use the path
          final audioPlayer = AudioPlayer();
          final duration = await audioPlayer.setUrl(file.path!);
          _audioFiles.add({
            'name': file.name,
            'duration': duration,
          });
          audioPlayer.dispose();
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Audio Files'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _selectAudioFiles,
              child: const Text('Select Audio Files'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _audioFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_audioFiles[index]['name']),
                    subtitle: Text('Duration: ${_audioFiles[index]['duration']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}