import 'package:another_flushbar/flushbar.dart';
import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void showSnackbar(BuildContext context, String message) {
  Flushbar(
    message: message,
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: blue,
    boxShadows: const [
      BoxShadow(
        blurRadius: 10,
        spreadRadius: -20,
      )
    ],
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.all(20),
    borderRadius: BorderRadius.circular(10),
  ).show(context);
}

Future<XFile?> pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  return image;
}

Future<CroppedFile?> cropImage(XFile image) async {
  final cropped = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ],
    uiSettings: [
      AndroidUiSettings(
        statusBarColor: Colors.black,
        hideBottomControls: true,
      ),
    ],
  );
  return cropped;
}

String formatTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}

String formatDate(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (dateTime.isAfter(today)) {
    return '';
  } else if (dateTime.isAfter(yesterday)) {
    return 'Yesterday';
  } else if (dateTime.weekday == now.weekday) {
    return DateFormat('EEEE').format(dateTime); // Display the day of the week
  } else {
    return DateFormat('dd.MM').format(dateTime); // Display the date
  }
}