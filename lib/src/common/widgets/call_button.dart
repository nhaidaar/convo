import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallButton extends StatelessWidget {
  final bool isVideoCall;
  final String resourceId;
  final List<String> id;
  final List<String> name;
  const CallButton({
    super.key,
    this.isVideoCall = false,
    required this.resourceId,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      icon: ButtonIcon(
        icon: Image.asset(
          'assets/icons/${isVideoCall ? 'video_call' : 'home_call'}.png',
          scale: 1.5,
        ),
      ),
      iconSize: const Size(30, 35),
      buttonSize: const Size(35, 35),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      isVideoCall: isVideoCall,
      resourceID: resourceId,
      invitees: List.generate(id.length, (index) {
        return ZegoUIKitUser(
          id: id[index],
          name: name[index],
        );
      }),
    );
  }
}
