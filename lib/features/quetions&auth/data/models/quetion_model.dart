import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/quetion.dart';

class QuetionModel extends Quetion {
  const QuetionModel(
      {required String id,
      required String quetion,
      required String answer,
      required List<String> options})
      : super(id: id, question: quetion, answer: answer, options: options);



  factory QuetionModel.fromJson(Map<String, dynamic> json) {
    return QuetionModel(
        id: json['id'],
        quetion: json['quetion'],
        answer: json['answer'],
        options: json['options'] != null ? json['options'].cast<String>() : []);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quetion': question,
      'answer': answer,
      'options': options
    };
  }

  factory QuetionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return QuetionModel(
      id: data?['id'],
      answer: data?['answer'],
      quetion: data?['quetion'],
      options:
      data?['options'] is Iterable ? List.from(data?['options']):[],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (answer != null) "answer": answer,
      if (question != null) "quetion": question,
      if (options != null) "options": options,
    };
  }
}

