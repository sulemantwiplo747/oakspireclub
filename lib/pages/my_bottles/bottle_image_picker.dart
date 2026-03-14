import 'dart:io';
import 'package:bourboneur/pages/my_bottles/add_to_collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottleImagePicker extends StatefulWidget {
  final Image? initialImage; // from blueBook (network image)
  final ValueChanged<File?>? onImagePicked; // optional: notify parent of local file

  const BottleImagePicker({
    super.key,
    this.initialImage,
    this.onImagePicked,
  });

  @override
  State<BottleImagePicker> createState() => _BottleImagePickerState();
}

class _BottleImagePickerState extends State<BottleImagePicker> {
  File? _pickedImageFile; // local file after picking
  final ImagePicker _picker = ImagePicker();

  bool get hasImage => _pickedImageFile != null || widget.initialImage != null;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, // good balance between quality & size (~80-90)
        maxWidth: 1200,   // optional: downscale for upload
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
        });
        widget.onImagePicked?.call(_pickedImageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xffff6f59)),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Color(0xffff6f59)),
                title: const Text('Take Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FieldLabel("Bottle Image"),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _showPickerOptions, // ← tap anywhere to pick/change
          child: Container(
            height: 250,
            padding: !hasImage ? const EdgeInsets.symmetric(horizontal: 15, vertical: 20) : null,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: hasImage ? Colors.white : null
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!hasImage) ...[
                  Image.asset("assets/images/camera.png", height: 120),
                  const SizedBox(height: 10),
                  const Text(
                    "Tap to add / change image",
                    style: TextStyle(color: Color(0xffff6f59), fontSize: 20),
                  ),
                ],
                if (hasImage)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.initialImage!, // fallback to network image from blueBook
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}