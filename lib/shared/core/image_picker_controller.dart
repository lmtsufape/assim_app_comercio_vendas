import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import for image resizing

class ImagePickerController with ChangeNotifier {
  Future<File?> pickImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(
          allowedExtensions: ['jpg'],
          type: FileType.custom);

      if (result != null) {
        File file = File(result.files.single.path!);

        // Resizing logic:
        File? resizedFile = await resizeImage(file);
        return resizedFile ?? file; // Return resized file if successful, otherwise original file
      } else {
        return null;
      }
    } catch (plataformException) {
      return null;
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      XFile? temp = await ImagePicker()
          .pickImage(source: ImageSource.camera);
      if (temp != null) {
        File file = File(temp.path);

        // Resizing logic:
        File? resizedFile = await resizeImage(file);
        return resizedFile ?? file; // Return resized file if successful, otherwise original file
      } else {
        return null;
      }
    } catch (cameraException) {
      return null;
    }
  }

  Future<File?> resizeImage(File imageFile) async {
    try {
      // Load the image using the image package
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) {
        return null; // Handle cases where image decoding fails
      }

      // Specify desired target dimensions (adjust as needed)
      int targetWidth = 500;
      int targetHeight = 500;

      // Calculate scaled image dimensions preserving aspect ratio
      double scale = min(targetWidth / image.width, targetHeight / image.height);
      int scaledWidth = (image.width * scale).round();
      int scaledHeight = (image.height * scale).round();

      // Create a new image with the scaled dimensions
      img.Image resizedImage = img.copyResize(image, width: scaledWidth, height: scaledHeight);

      // Encode the resized image as a PNG and save it to a new file
      File resizedFile = await File('${imageFile.path}_resized.jpg').create();
      await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

      return resizedFile;
    } catch (error) {
      print('Error resizing image: $error');
      return null;
    }
  }
}