import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/auth/user.dart';

class UserDataModel extends UserData {
  const UserDataModel(
      {required String id,
      required String name,
      required String email,
      required String photourl,
      required String rate,
      required bool isTested,
      required String addtime})
      : super(
            id: id,
            name: name,
            email: email,
            photourl: photourl,
            rate: rate,
            isTested: isTested,
            addtime: addtime);

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
      isTested: data?['is_tested'],
      addtime: data?['addtime'],
    );
  }

  factory UserDataModel.fromJson(Map<String, dynamic> data) {
    return UserDataModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      photourl: data['photourl'],
      rate: data['rate'],
      isTested: data['is_tested'],
      addtime: data['addtime'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photourl != null) "photourl": photourl,
      if (rate != null) "rate": rate,
      if (isTested != null) "is_tested": isTested,
      if (addtime != null) "addtime": addtime,
    };
  }
}
