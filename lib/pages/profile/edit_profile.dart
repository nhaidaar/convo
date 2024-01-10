import 'dart:io';

import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: semiboldTS,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          children: [
            GestureDetector(
              onTap: () async {
                final picked = await pickImage();
                if (picked != null) {
                  final cropped = await cropImage(picked);
                  if (cropped != null) {
                    setState(() {
                      image = File(cropped.path);
                    });
                  }
                }
              },
              child: Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade300,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        widget.user.profilePicture.toString(),
                      ),
                      foregroundImage: image != null ? FileImage(image!) : null,
                      child: Image.asset(
                        'assets/icons/add_photo.png',
                        scale: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Display Name',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    // controller: displayNameController,
                    keyboardType: TextInputType.name,
                    hintText: 'John Doe',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Username',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    // controller: displayNameController,
                    keyboardType: TextInputType.name,
                    hintText: '@johndoe',
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: CustomButton(
              action: () {},
              title: 'Coming Soon',
              disabled: true,
            ),
          ),
        ),
      ),
    );
  }
}
