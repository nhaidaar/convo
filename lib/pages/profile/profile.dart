import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('assets/images/male1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'Naufal Haidar',
                style: semiboldTS.copyWith(fontSize: 24, height: 2),
              ),
              Text(
                'nhaidaar@icloud.com',
                style: mediumTS.copyWith(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(
              'Edit Profile',
              style: mediumTS.copyWith(fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(
              'Edit Profile',
              style: mediumTS.copyWith(fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
            leading: const Icon(Icons.logout),
            title: Text(
              'Log out',
              style: mediumTS.copyWith(fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
