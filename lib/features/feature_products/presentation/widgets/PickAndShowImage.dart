/*
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickAndShowImage extends StatefulWidget {
  const PickAndShowImage({super.key});

  @override
  State<PickAndShowImage> createState() => _PickAndShowImageState();
}

class _PickAndShowImageState extends State<PickAndShowImage> {
  final ImagePicker _picker = ImagePicker();

  // موبایل/دسکتاپ: مسیر فایل؛ وب: بایت‌ها
  File? _imageFile;
  Uint8List? _webBytes;

  Future<void> _pickFromGallery() async {
    final XFile? x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,      // کمی فشرده‌سازی برای حجم کمتر
      maxWidth: 2048,        // محدود کردن اندازه برای جلوگیری از OOM
    );
    if (x == null) return;

    if (kIsWeb) {
      final bytes = await x.readAsBytes();
      setState(() {
        _webBytes = bytes;
        _imageFile = null;
      });
    } else {
      setState(() {
        _imageFile = File(x.path);
        _webBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget preview = () {
      if (kIsWeb && _webBytes != null) {
        return Image.memory(_webBytes!, fit: BoxFit.cover);
      }
      if (!kIsWeb && _imageFile != null) {
        return Image.file(_imageFile!, fit: BoxFit.cover);
      }
      return const Center(
        child: Text('هنوز عکسی انتخاب نشده'),
      );
    }();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: _pickFromGallery,
          icon: const Icon(Icons.photo_library),
          label: const Text('انتخاب از گالری'),
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.6, // هرنسبتی که دوست داری
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.black12,
              child: preview,
            ),
          ),
        ),
      ],
    );
  }
}
*/
