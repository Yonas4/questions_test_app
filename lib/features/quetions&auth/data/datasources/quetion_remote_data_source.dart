import '../../../../core/error/exceptions.dart';
import '../models/quetion_model.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class QuetionRemoteDataSource {
  Future<List<QuetionModel>> getAllQuetions();
}

class QuetionRemoteDataSourceImpl implements QuetionRemoteDataSource {
  final http.Client client;
  final db = FirebaseFirestore.instance;

  QuetionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<QuetionModel>> getAllQuetions() async {
    //جلب الاسئله من الفايربيس

    final ref = await db
        .collection("quetions")
        .withConverter(
          fromFirestore: QuetionModel.fromFirestore,
          toFirestore: (QuetionModel quetionModel, _) =>
              quetionModel.toFirestore(),
        )
        .get();
    // final docSnap = await ref.get();
    // print(ref.hashCode.toString() + '----------------------------');

    //اذا كانت البيانات ليست فارغه نقوم بتخزينها في list
    final quetion = ref.docs;
    if (quetion != null) {
      print(quetion.first.data().options);

      List<QuetionModel> quetionModels = [];
      quetion.forEach((element) {
        quetionModels.add(element.data());
      });
      //ارجاع قائمه بالاسئله
      return quetionModels;
    } else {
      //ارجاع خطا اذا كانت ليست موجودده
      print("No such document.");
      throw ServerException();
    }
  }
}
