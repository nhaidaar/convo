class UserModel {
  final String? uid;
  final String? username;
  final String? credentials;
  final String? displayName;
  final String? profilePicture;
  final String? lastActive;
  final bool? isOnline;
  final String? pushToken;

  UserModel({
    this.uid,
    this.username,
    this.credentials,
    this.displayName,
    this.profilePicture,
    this.lastActive,
    this.isOnline,
    this.pushToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'credentials': credentials,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'lastActive': lastActive,
      'isOnline': isOnline,
      'pushToken': pushToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      credentials: map['credentials'] ?? '',
      displayName: map['displayName'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      lastActive: map['lastActive'] ?? '',
      isOnline: map['isOnline'] ?? '',
      pushToken: map['pushToken'] ?? '',
    );
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? credentials,
    String? displayName,
    String? profilePicture,
    String? lastActive,
    bool? isOnline,
    String? pushToken,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        credentials: credentials ?? this.credentials,
        displayName: displayName ?? this.displayName,
        profilePicture: profilePicture ?? this.profilePicture,
        lastActive: lastActive ?? this.lastActive,
        isOnline: isOnline ?? this.isOnline,
        pushToken: pushToken ?? this.pushToken,
      );
}
