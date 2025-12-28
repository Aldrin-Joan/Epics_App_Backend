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
    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() => _fileName = result.files.first.name);
    }
  }

  Future<void> _startUpload() async {
    if (_fileName == null || _uploading) return;

    setState(() {
      _uploading = true;
      _progress = 0.0;
    });

    while (_progress < 1.0 && mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _progress = (_progress + 0.15).clamp(0.0, 1.0));
    }

    if (!mounted) return;

    setState(() => _uploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uploaded "$_fileName" successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Documents'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 56,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Upload Case Documents',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PDF, DOCX, or images supported',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    /// File picker
                    FilledButton.icon(
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Select File'),
                      onPressed: _uploading ? null : _pickFile,
                    ),

                    const SizedBox(height: 16),

                    /// File info
                    if (_fileName != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_drive_file),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _fileName!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Progress
                      LinearProgressIndicator(
                        value: _uploading ? _progress : null,
                      ),
                      const SizedBox(height: 16),

                      /// Upload button
                      FilledButton(
                        onPressed: _uploading ? null : _startUpload,
                        child: _uploading
                            ? const Text('Uploading...')
                            : const Text('Upload'),
                      ),
                    ] else ...[
                      Text(
                        'No file selected',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
