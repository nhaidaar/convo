class CallModel {
  final String? callId;
  final bool? isVideo;
  final List<String>? participant;
  final String? callAt;
  final bool? isAccepted;
  final bool? isDeclined;

  CallModel({
    this.callId,
    this.isVideo,
    this.participant,
    this.callAt,
    this.isAccepted,
    this.isDeclined,
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId ?? '',
      'isVideo': isVideo ?? false,
      'participant': participant ?? [],
      'callAt': callAt ?? '',
      'isAccepted': isAccepted ?? false,
      'isDeclined': isDeclined ?? false,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'] ?? '',
      isVideo: map['isVideo'] ?? false,
      participant: List<String>.from(map['participant']),
      callAt: map['callAt'] ?? '',
      isAccepted: map['isAccepted'] ?? false,
      isDeclined: map['isDeclined'] ?? false,
    );
  }
}
