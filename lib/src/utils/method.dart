import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../features/chat/domain/bloc/chat_bloc.dart';
import '../common/widgets/custom_button.dart';

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
  final image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );
  return image;
}

Future<XFile?> pickCamera() async {
  final image = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 90,
  );
  return image;
}

Future<List<XFile>> pickMultiImage() async {
  final image = await ImagePicker().pickMultiImage(imageQuality: 80);
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

void clickImage(BuildContext context, {required String imageUrl}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocProvider(
                create: (context) => ChatBloc(),
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSuccess) {
                      Navigator.of(context).pop();
                      showSnackbar(context, 'Image saved!');
                    }

                    if (state is ChatError) {
                      showSnackbar(context, state.e);
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const LoadingButton();
                    }
                    return CustomButton(
                      title: 'Save Image',
                      onTap: () {
                        context.read<ChatBloc>().add(SaveImageEvent(imageUrl));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}

Future<void> saveImage(String url) async {
  final response = await http.get(Uri.parse(url));
  await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.bodyBytes),
    quality: 90,
  );
}

String formatTimeForLastMessage(String time) {
  final int i = int.tryParse(time) ?? -1;
  if (i == -1) return '';

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(i);

  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (dateTime.isAfter(today)) {
    return DateFormat('HH:mm').format(dateTime);
  } else if (dateTime.isAfter(yesterday)) {
    return 'Yesterday';
  } else {
    return DateFormat('dd/MM/yy').format(dateTime); // Display the date
  }
}

String formatTimeForChat(String time) {
  final int i = int.tryParse(time) ?? -1;
  if (i == -1) return '';

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(i);
  String timeOnly = DateFormat('HH:mm').format(dateTime);

  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (dateTime.isAfter(today)) {
    return timeOnly;
  } else if (dateTime.isAfter(yesterday)) {
    return 'Yesterday $timeOnly';
  } else {
    return '${DateFormat('dd MMM').format(dateTime)} $timeOnly'; // Display the date
  }
}

String cleanUsernameSearch(String value) {
  return value.replaceAll(RegExp(r'[^a-zA-Z0-9_.]'), '');
}

String getLastActiveTime({
  required BuildContext context,
  required String lastActive,
}) {
  final int i = int.tryParse(lastActive) ?? -1;
  if (i == -1) return 'Last seen not available';

  DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
  DateTime now = DateTime.now();

  String formattedTime = TimeOfDay.fromDateTime(time).format(context);
  if (time.day == now.day && time.month == now.month && time.year == time.year) {
    return 'Last seen today at $formattedTime';
  }

  if ((now.difference(time).inHours / 24).round() == 1) {
    return 'Last seen yesterday at $formattedTime';
  }

  String month = DateFormat('MMM').format(time);
  return 'Last seen ${time.day} $month at $formattedTime';
}
