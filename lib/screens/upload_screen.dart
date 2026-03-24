import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _fileName;
  bool _uploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (!mounted) return;

    if (result != null && result.files.isNotEmpty) {
      setState(() => _fileName = result.files.first.name);
    }
  }

  void _analyzeDocument() {
    if (_fileName == null) return;
    setState(() => _uploading = true);

    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _uploading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Analyzing $_fileName... Done!')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          "Review Contract",
          style: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textPrimaryLight,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Area
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ), // TODO: Dashed border ideally
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_rounded,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _fileName ?? "Click to upload or drag and drop",
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "PDF, DOCX, TXT up to 10MB",
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Analyze Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _fileName != null && !_uploading
                    ? _analyzeDocument
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _uploading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Analyze Document",
                            style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Recent Files
            Text(
              "Recent Files",
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            _buildRecentFileItem(
              "Employment_Contract_v1.pdf",
              "2 hours ago",
              true,
            ),
            _buildRecentFileItem("NDA_Draft_Final.docx", "Yesterday", false),
            _buildRecentFileItem("Lease_Agreement_2024.pdf", "Oct 24", true),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentFileItem(String name, String date, bool isPdf) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPdf
                  ? const Color(0xFFFFE2E5)
                  : const Color(0xFFE3F2FD), // Red for PDF, Blue for Doc
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
              color: isPdf ? const Color(0xFFF64E60) : const Color(0xFF3699FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondaryLight,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
