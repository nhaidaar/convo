import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/chats/group_setprofile.dart';
import 'package:convo/pages/chats/widgets/search_card.dart';
import 'package:convo/pages/chats/widgets/selected_member_card.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<UserModel> members = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => UserBloc(),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Create New Group',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                children: [
                  (members.isNotEmpty)
                      ? Text(
                          'Selected Members',
                          style: mediumTS.copyWith(fontSize: 16),
                        )
                      : Container(),
                  (members.isNotEmpty)
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        members.length,
                        (index) {
                          return SelectedMemberCard(
                            action: () {
                              setState(() {
                                members.remove(members[index]);
                              });
                            },
                            user: members[index],
                          );
                        },
                      ),
                    ),
                  ),
                  (members.isNotEmpty)
                      ? const SizedBox(
                          height: 20,
                        )
                      : Container(),
                  Text(
                    'Search by Username',
                    style: mediumTS.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomRoundField(
                    onFieldSubmitted: (value) {
                      if (value!.isNotEmpty) {
                        BlocProvider.of<UserBloc>(context).add(
                          SearchUserEvent(
                            search: cleanUsernameSearch(value),
                            exceptUid: currentUser!.uid,
                          ),
                        );
                      }
                    },
                    prefixIconUrl: 'assets/icons/search.png',
                    fillColor: Colors.grey.shade100,
                    borderColor: Colors.grey.shade400,
                    hintText: '@johndoe',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    (state is UserSearchSuccess || state is UserLoading)
                        ? 'Search Result'
                        : '',
                    style: mediumTS.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (state is UserSearchSuccess)
                      ? state.userList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'User Not Found',
                                style: regularTS,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Column(
                              children: state.userList.map((user) {
                                return SearchCard(
                                  model: user,
                                  action: () {
                                    if (!members.contains(user)) {
                                      setState(() {
                                        members.add(user);
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            )
                      : (state is UserLoading)
                          ? Center(
                              child: CircularProgressIndicator(color: blue),
                            )
                          : Container(),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: CustomButton(
                    title: 'Next',
                    disabled: members.isEmpty,
                    action: () async {
                      if (members.isNotEmpty) {
                        Navigator.of(context).push(
                          PageTransition(
                            child: CreateGroupNext(members: members),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      }
                    },

                    // invert: true,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
