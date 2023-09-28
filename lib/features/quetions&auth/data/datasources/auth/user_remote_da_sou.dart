import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/data/models/user_model.dart';

import '../../../../../core/error/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<List<UserDataModel>> getAllUsers();

  Future<Unit> updateUsers(UserDataModel userModel);

  Future<Unit> addUsers(UserDataModel userModel);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // final http.Client client;
  final db = FirebaseFirestore.instance;

  @override
  Future<List<UserDataModel>> getAllUsers() async {
    final ref = await db
        .collection("Users")
        .withConverter(
          fromFirestore: UserDataModel.fromFirestore,
          toFirestore: (UserDataModel userDataModel, _) =>
              userDataModel.toFirestore(),
        )
        .get();
    // final docSnap = await ref.get();
    print(ref.hashCode.toString() + '----------------------------');

    final quetion = ref.docs;
    if (quetion != null) {
      print(quetion.first.data().rate);

      List<UserDataModel> userModels = [];
      quetion.forEach((element) {
        userModels.add(element.data());
      });
      return userModels;
    } else {
      print("No such document.");
      throw ServerException();
    }
  }

  @override
  Future<Unit> addUsers(UserDataModel userModel) async {
    final docRef = db
        .collection("Users").doc(userModel.id)
        .withConverter(
          fromFirestore: UserDataModel.fromFirestore,
          toFirestore: (UserDataModel userDataModel, options) =>
              userDataModel.toFirestore(),
        ).set(userModel);
    // await docRef.set(userModel).then((value) =>
    //     return Future.value(unit);
    // );
    docRef.onError((error, stackTrace) =>
    return ServerException()
    );

  }

  @override
  Future<Unit> updateUsers(UserDataModel userModel) {
    // TODO: implement updateUsers
    throw UnimplementedError();
  }
}
