import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:questions/features/quetions&auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/error/exceptions.dart';

abstract class UsersLocalDataSource {
  Future<List<UserDataModel>> getCachedUsers();

  Future<UserDataModel> getCachedUser();

  Future<Unit> cacheUsers(List<UserDataModel> userDataModel);

  Future<Unit> cacheUser(UserDataModel userDataModel);
}

const CACHED_USERS = "CACHED_USERS";
const CACHED_USER = "CACHED_USER";

class UsersLocalDataSourceImpl implements UsersLocalDataSource {
  final SharedPreferences sharedPreferences;

  UsersLocalDataSourceImpl({required this.sharedPreferences});

  //users cache
  @override
  Future<Unit> cacheUsers(List<UserDataModel> userDataModel) {
    List userModelsToJson = userDataModel
        .map<Map<String, dynamic>>((userModel) => userModel.toFirestore())
        .toList();
    print(userDataModel.first.email);
    sharedPreferences.setString(CACHED_USERS, json.encode(userModelsToJson));
    return Future.value(unit);
  }
//جلب المستخددمين من التخزين المحلي
  @override
  Future<List<UserDataModel>> getCachedUsers() {
    final jsonString = sharedPreferences.getString(CACHED_USERS);
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<UserDataModel> jsonToUserModels = decodeJsonData
          .map<UserDataModel>(
              (jsonUserModel) => UserDataModel.fromJson(jsonUserModel))
          .toList();
      return Future.value(jsonToUserModels);
    } else {
      throw EmptyCacheException();
    }
  }

  // current user cache
  @override
  Future<Unit> cacheUser(UserDataModel userDataModel) {
    final userData = userDataModel.toFirestore();
    print(userData);
    sharedPreferences.setString(CACHED_USER, json.encode(userData));
    return Future.value(unit);
  }
//جلب المستخدم من التخزين المحلي
  @override
  Future<UserDataModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    print('loacal--------------' + jsonString.toString());
    if (jsonString != null) {
      final decodeJsonData = json.decode(jsonString);
      final jsonToUserModels = UserDataModel.fromJson(decodeJsonData);

      return Future.value(jsonToUserModels);
    } else {
      UserDataModel userDataModel = UserDataModel(
          id: 'id',
          name: 'name',
          email: 'email',
          photourl: 'photourl',
          rate: 'rate',
          isTested: false,
          addtime: Timestamp.now().seconds.toString());

      return Future.value(userDataModel);
    }
  }
}
