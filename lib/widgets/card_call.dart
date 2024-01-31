import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/config/method.dart';
import 'package:convo/models/call_model.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/call_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/user_model.dart';
import '../services/zego_services.dart';
import 'default_avatar.dart';

class CallCard extends StatefulWidget {
  final CallModel model;
  const CallCard({super.key, required this.model});

  @override
  State<CallCard> createState() => _CallCardState();
}

class _CallCardState extends State<CallCard> {
  final user = FirebaseAuth.instance.currentUser;

  late bool isOutgoing;
  List<UserModel> callFriends = [];
  String resourceId = '';

  @override
  void initState() {
    getResourceId();
    getCallMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      child: Row(
        children: [
          callFriends.length == 1
              ? CachedNetworkImage(
                  imageUrl: callFriends.first.profilePicture.toString(),
                  imageBuilder: (context, imageProvider) {
                    return DefaultAvatar(
                      image: imageProvider,
                    );
                  },
                  placeholder: (context, url) {
                    return const DefaultAvatar();
                  },
                )
              : CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade300,
                  child: Text('${callFriends.length}+'),
                ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  callFriends.map((callFriend) => callFriend.displayName).toList().join(', '),
                  style: semiboldTS.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/${isOutgoing ? 'outgoing' : 'incoming'}_call.png',
                      scale: 3,
                      color: widget.model.isAccepted! ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${formatTimeForChat(widget.model.callAt!)} - ${widget.model.isAccepted! ? 'Accepted' : widget.model.isDeclined! ? 'Rejected' : 'Not answered'}',
                      style: mediumTS.copyWith(
                        fontSize: 15,
                        color: widget.model.isAccepted! ? Colors.green : Colors.red,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            ),
          ),
          CallButton(
            resourceId: resourceId,
            isVideoCall: widget.model.isVideo!,
            id: callFriends.map((callFriend) => callFriend.uid!).toList(),
            name: callFriends.map((callFriend) => callFriend.displayName!).toList(),
          ),
        ],
      ),
    );
  }

  void getCallMember() {
    // Set call status
    setState(() {
      isOutgoing = widget.model.participant!.first == user!.uid;
    });

    // Clear list from my uid
    widget.model.participant!.remove(user!.uid);

    // Get call member data
    for (String uid in widget.model.participant!) {
      UserService().getUserData(uid).then((value) {
        if (value != null) {
          callFriends.add(value);
          setState(() {});
        }
      });
    }
  }

  void getResourceId() {
    ZegoService().getResourceId().then((value) {
      if (value != null) {
        setState(() => resourceId = value);
      }
    });
  }
}
