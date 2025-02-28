import 'dart:io';

import 'package:firebase/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImageGallery();
              },
              child: _image != null ? Image.file(_image!.absolute) : Center(
                child: Container(
                    height: 150,
                    width: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Icon(
                      Icons.image,
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
              onTap: () {},
              title: 'Upload',
            )
          ],
        ),
      ),
    );
  }
}
