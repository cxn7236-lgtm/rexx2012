import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/video_service.dart';
import '../services/auth_service.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final VideoService _videoService = VideoService();
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();
  
  File? _selectedVideo;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        setState(() {
          _selectedVideo = File(video.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في اختيار الفيديو: $e';
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_selectedVideo == null) {
      setState(() {
        _errorMessage = 'يرجى اختيار فيديو';
      });
      return;
    }

    if (_titleController.text.isEmpty) {
      setState(() {
        _errorMessage = 'يرجى إدخال عنوان الفيديو';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.getCurrentUser();

      if (user == null) {
        setState(() {
          _errorMessage = 'يرجى تسجيل الدخول أولاً';
          _isUploading = false;
        });
        return;
      }

      final video = await _videoService.uploadVideo(
        videoFile: _selectedVideo!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        uid: user.uid,
        username: user.username,
      );

      if (video != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحميل الفيديو بنجاح!')),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'فشل تحميل الفيديو، حاول مرة أخرى';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحميل فيديو جديد'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // اختيار الفيديو
            GestureDetector(
              onTap: _isUploading ? null : _pickVideo,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF6A1B9A),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedVideo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.video_library,
                            size: 60,
                            color: Color(0xFF6A1B9A),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'اضغط لاختيار فيديو',
                            style: TextStyle(
                              color: Color(0xFF6A1B9A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 60,
                            color: Colors.green,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'تم اختيار فيديو',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _selectedVideo!.path.split('/').last,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 24),
            // عنوان الفيديو
            TextField(
              controller: _titleController,
              enabled: !_isUploading,
              decoration: InputDecoration(
                labelText: 'عنوان الفيديو',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              maxLength: 100,
            ),
            SizedBox(height: 16),
            // وصف الفيديو
            TextField(
              controller: _descriptionController,
              enabled: !_isUploading,
              decoration: InputDecoration(
                labelText: 'وصف الفيديو (اختياري)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
            SizedBox(height: 16),
            // رسالة الخطأ
            if (_errorMessage != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            SizedBox(height: 24),
            // زر التحميل
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6A1B9A),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isUploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('جاري التحميل...')
                      ],
                    )
                  : Text(
                      'تحميل الفيديو',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
