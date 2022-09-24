import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class SelectionCameraGallery extends StatelessWidget {
  const SelectionCameraGallery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Choose option',
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                _pickImage(context, ImageSource.gallery);
              },
              title: const Text('Gallery'),
              leading: const Icon(
                Icons.account_box,
              ),
            ),
            const Divider(
              height: 1,
            ),
            ListTile(
              onTap: () {
                _pickImage(context, ImageSource.camera);
              },
              title: const Text('Camera'),
              leading: const Icon(
                Icons.camera,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
    );
    if (imageFile == null) return;
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    Navigator.pop(context, savedImage);
  }
}
