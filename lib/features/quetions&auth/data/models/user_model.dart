import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth/user.dart';

class UserDataModel extends UserData {
  const UserDataModel(
      {required String id,
      required String name,
      required String email,
      required String photourl,
      required String rate,
      required String fcmtoken,
      required Timestamp addtime})
      : super(
            id: id,
            name: name,
            email: email,
            photourl: photourl,
            rate: rate,
            fcmtoken: fcmtoken,
            addtime: addtime
  );

  factory UserDataModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserDataModel(
      id: data?['id'],
      name: data?['name'],
      email: data?['email'],
      photourl: data?['photourl'],
      rate: data?['rate'],
      fcmtoken: data?['fcmtoken'],
      addtime: data?['addtime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photourl != null) "photourl": photourl,
      if (rate != null) "rate": rate,
      if (fcmtoken != null) "fcmtoken": fcmtoken,
      if (addtime != null) "addtime": addtime,
    };
  }
}
