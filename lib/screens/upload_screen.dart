import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _fileName;
  double _progress = 0.0;
  bool _uploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() => _fileName = result.files.first.name);
    }
  }

  void _startUpload() {
    if (_fileName == null) return;
    setState(() {
      _uploading = true;
      _progress = 0.0;
    });
    // Simulate upload
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _progress = (_progress + 0.2).clamp(0.0, 1.0));
      if (_progress >= 1.0) {
        setState(() => _uploading = false);
        if (!mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded "$_fileName" successfully')),
        );
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Documents')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Select file'),
            ),
            const SizedBox(height: 16),
            if (_fileName != null) ...[
              Text('Selected file: $_fileName'),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: _uploading ? _progress : null),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _uploading ? null : _startUpload,
                child: const Text('Upload'),
              ),
            ] else ...[
              const Text('No file selected yet.'),
            ],
          ],
        ),
      ),
    );
  }
}
