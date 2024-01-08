class UserModel {
  final String? uid;
  final String? username;
  final String? credentials;
  final String? displayName;
  final String? profilePicture;

  UserModel({
    this.uid,
    this.username,
    this.credentials,
    this.displayName,
    this.profilePicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'credentials': credentials,
      'displayName': displayName,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      credentials: map['credentials'],
      displayName: map['displayName'],
      profilePicture: map['profilePicture'],
    );
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? credentials,
    String? displayName,
    String? profilePicture,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        username: username ?? this.username,
        credentials: credentials ?? this.credentials,
        displayName: displayName ?? this.displayName,
        profilePicture: profilePicture ?? this.profilePicture,
      );
}
