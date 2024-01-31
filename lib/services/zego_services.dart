import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/models/call_model.dart';
import 'package:convo/services/call_services.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/default_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../blocs/user/user_bloc.dart';

class ZegoService {
  final storage = const FlutterSecureStorage();
  final _firestore = FirebaseFirestore.instance.collection('config');

  Future<void> getZegoAPI() async {
    await _firestore.doc('zego').get().then((value) async {
      final zego = value.data();
      await writeZegoAPI(
        appId: zego!['appId'],
        appSign: zego['appSign'],
        resourceId: zego['resourceId'],
      );
    });
  }

  Future<void> writeZegoAPI({
    required String appId,
    required String appSign,
    required String resourceId,
  }) async {
    await storage.write(key: 'appId', value: appId);
    await storage.write(key: 'appSign', value: appSign);
    await storage.write(key: 'resourceId', value: resourceId);
  }

  Future<Map<String, dynamic>> readZegoAPI() async {
    await getZegoAPI();
    final zego = await storage.readAll();
    return zego;
  }

  Future<String?> getResourceId() async {
    final resourceId = await storage.read(key: 'resourceId');
    return resourceId;
  }

  Future<void> initZego() async {
    readZegoAPI().then((api) {
      UserService().getSelfData().then((value) {
        if (value != null) {
          ZegoUIKitPrebuiltCallInvitationService().init(
            appID: int.tryParse(api['appId']) ?? 0,
            appSign: api['appSign'],
            userID: value.uid.toString(),
            userName: value.displayName.toString(),
            plugins: [ZegoUIKitSignalingPlugin()],
            requireConfig: (data) {
              var config = (data.invitees.length > 1)
                  ? ZegoCallType.videoCall == data.type
                      ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                      : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                  : ZegoCallType.videoCall == data.type
                      ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                      : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

              config.durationConfig.isVisible = true;

              config.avatarBuilder = (context, size, user, extraInfo) {
                return user != null
                    ? BlocProvider(
                        create: (context) => UserBloc()..add(GetUserDataEvent(user.id)),
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserGetDataSuccess) {
                              return CachedNetworkImage(
                                imageUrl: state.model.profilePicture.toString(),
                                imageBuilder: (context, imageProvider) {
                                  return DefaultAvatar(
                                    radius: size.width / 2,
                                    image: imageProvider,
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      )
                    : Container();
              };
              return config;
            },
            invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
              onIncomingCallReceived: (callID, caller, callType, callees, customData) {
                List<String> uid = [];
                uid.add(caller.id);
                uid.addAll(callees.map((callee) => callee.id));

                CallService().postCallData(CallModel(
                  callId: callID,
                  isVideo: callType == ZegoCallType.videoCall,
                  participant: uid,
                  callAt: DateTime.now().millisecondsSinceEpoch.toString(),
                ));
              },
              onOutgoingCallAccepted: (callID, callee) {
                CallService().callAccepted(callID);
              },
              onOutgoingCallDeclined: (callID, callee, customData) {
                CallService().callDeclined(callID);
              },
              onOutgoingCallRejectedCauseBusy: (callID, callee, customData) {
                CallService().callDeclined(callID);
              },
            ),
          );
        }
      });
    });
  }
}
