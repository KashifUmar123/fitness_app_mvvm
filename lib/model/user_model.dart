import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? uid;
  String? name;
  String? email;
  String? weight;
  String? height;
  int? dob;
  String? gender;
  String? profileImage;
  DateTime timestamp;
  DateTime? subscriptionData;
  String? stripId;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.weight,
    this.height,
    this.dob,
    this.gender,
    this.profileImage,
    required this.timestamp,
    this.subscriptionData,
    this.stripId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'weight': weight,
      'height': height,
      'dob': dob,
      'gender': gender,
      'profileImage': profileImage,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'subscriptionData': subscriptionData?.millisecondsSinceEpoch,
      'stripId': stripId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      weight: map['weight'] != null ? map['weight'] as String : null,
      height: map['height'] != null ? map['height'] as String : null,
      dob: map['dob'] != null ? map['dob'] as int : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      subscriptionData: map['subscriptionData'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['subscriptionData'] as int)
          : null,
      stripId: map['stripId'] != null ? map['stripId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
