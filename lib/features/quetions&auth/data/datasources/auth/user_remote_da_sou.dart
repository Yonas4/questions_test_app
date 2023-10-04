import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:questions/features/quetions&auth/data/datasources/auth/user_local_data_source.dart';
import 'package:questions/features/quetions&auth/data/models/user_model.dart';
import 'package:questions/notifications.dart';

import '../../../../../core/error/exceptions.dart';

abstract class UserRemoteDataSource {
  Future<List<UserDataModel>> getAllUsers();

  Future<Unit> updateUsers(UserDataModel userModel);

  Future<Unit> addUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // final http.Client client;
  final UsersLocalDataSource localDataSource;
  final db = FirebaseFirestore.instance;

  UserRemoteDataSourceImpl({required this.localDataSource});

  @override
  Future<List<UserDataModel>> getAllUsers() async {

    //جلب كل المستخدمين من الفايربيس
    final ref = await db
        .collection("users")
        .withConverter(
          fromFirestore: UserDataModel.fromFirestore,
          toFirestore: (UserDataModel userDataModel, _) =>
              userDataModel.toFirestore(),
        )
        .where("is_tested", isEqualTo: true)
        .get();

    print(ref.docs.toString() + '----------------------------');

    //اذا كانت البيانات ليست فارغه نقوم بتخزينها في list
    final user = ref.docs;
    if (user.isNotEmpty) {
      print(user.first.data().rate);
      if (user.first.exists) {
        List<UserDataModel> userModels = [];
        user.forEach((element) {
          userModels.add(element.data());
        });
        //ارجاع قائمه بالمستخدمين
        return userModels;
      } else {
        //ارجاع خطا اذا كانت ليست موجودده
        throw ServerException();
      }
    } else {
      // ارجاع ان المستخدمين فارغين اي لا يوجد مستخدمين
      print("No such document.");
      throw EmptyException();
    }
  }

  @override
  Future<Unit> addUsers() async {
    final db = FirebaseFirestore.instance;
    // Trigger the authentication flow

    //تسجيل الدخول باستخدام جووجل
    final GoogleSignIn googleUser = GoogleSignIn(scopes: <String>['openid']);

    var user = await googleUser.signIn();

    if (user != null) {
      final gAuthentication = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuthentication.accessToken,
        idToken: gAuthentication.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      //جلب  بيانات المستخدم من الفايربيس للتاكدد اذ كان موجود

      final docRef = await db
          .collection("users")
          .withConverter(
            fromFirestore: UserDataModel.fromFirestore,
            toFirestore: (UserDataModel userDataModel, options) =>
                userDataModel.toFirestore(),
          )
          .where('id', isEqualTo: user.id)
          .get();

      print('-----------------------addUser');
      final userDataModel = UserDataModel(
          id: user.id,
          name: user.displayName ?? user.email,
          email: user.email,
          photourl: user.photoUrl ?? '',
          isTested:
              docRef.docs.isEmpty ? false : docRef.docs.first.data().isTested,
          rate: docRef.docs.isEmpty ? '0' : docRef.docs.first.data().rate,
          addtime: Timestamp.now().seconds.toString());

      //اذا كان البيانات فارغه يعني انه لايوجد مستخدم بال id المرسل لذلك نقوم بتخزينه في الفايربيس

      if (docRef.docs.isEmpty) {
        print('-----------------------addUser notEmpty');

        //set user data in data base firestore
        await db
            .collection("users")
            .doc(userDataModel.id)
            .withConverter(
              fromFirestore: UserDataModel.fromFirestore,
              toFirestore: (UserDataModel userDataModel, options) =>
                  userDataModel.toFirestore(),
            )
            .set(userDataModel);
      }
      //cache user data
      localDataSource.cacheUser(userDataModel);

      //return null if done
      return Future.value(unit);
    } else {
      //return exception if error
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateUsers(UserDataModel userModel) async {
    try {

      //update user  { rate ,isTested}
      await db
          .collection("users")
          .doc(userModel.id)
          .withConverter(
            fromFirestore: UserDataModel.fromFirestore,
            toFirestore: (UserDataModel userDataModel, options) =>
                userDataModel.toFirestore(),
          )
          .update({'is_tested': userModel.isTested, 'rate': userModel.rate});
      final id = OneSignal.User.pushSubscription.id;

      //send notification after submit test

      Notifications().sendNotification(id.toString(),
          'your score is ${userModel.rate}', 'The test has been sent');

      //cacheUser with new data
      localDataSource.cacheUser(userModel);

      //return null if done
      return Future.value(unit);
    } on Exception catch (e) {
      //return exception if error
      throw ServerException();
    }
  }
}
