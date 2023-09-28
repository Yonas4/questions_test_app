import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../models/quetion_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class QuetionRemoteDataSource {
  Future<List<QuetionModel>> getAllQuetions();

  // Future<Unit> deleteQuetions(int postId);
  Future<Unit> updateQuetions(QuetionModel quetionModel);

  Future<Unit> addQuetions(QuetionModel quetionModel);
}

const BASE_URL = "https://jsonplaceholder.typicode.com";

class QuetionRemoteDataSourceImpl implements QuetionRemoteDataSource {
  final http.Client client;
  final db = FirebaseFirestore.instance;

  QuetionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<QuetionModel>> getAllQuetions() async {
    final ref = await db
        .collection("quetions")
        .withConverter(
          fromFirestore: QuetionModel.fromFirestore,
          toFirestore: (QuetionModel quetionModel, _) =>
              quetionModel.toFirestore(),
        )
        .get();
    // final docSnap = await ref.get();
    print(ref.hashCode.toString() + '----------------------------');

    final quetion = ref.docs; // Convert to City object
    if (quetion != null) {
      print(quetion.first.data().options);

      List<QuetionModel> quetionModels = [];
      quetion.forEach((element) {
        quetionModels.add(element.data());
      });
      return quetionModels;
    } else {
      print("No such document.");
      throw ServerException();
    }
  }

  @override
  Future<Unit> addQuetions(QuetionModel quetionModel) async {
    final body = {
      // "title": quetionModel.title,
      // "body": quetionModel.body,
    };

    final response =
        await client.post(Uri.parse(BASE_URL + "/posts/"), body: body);
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  // @override
  // Future<Unit> deleteQuetions(int postId) async {
  //   final response = await client.delete(
  //     Uri.parse(BASE_URL + "/posts/${postId.toString()}"),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     return Future.value(unit);
  //   } else {
  //     throw ServerException();
  //   }
  // }

  @override
  Future<Unit> updateQuetions(QuetionModel postModel) async {
    final postId = postModel.id.toString();
    final body = {
      // "title": postModel.title,
      // "body": postModel.body,
    };

    final response = await client.patch(
      Uri.parse(BASE_URL + "/posts/$postId"),
      body: body,
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
