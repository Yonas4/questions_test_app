import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String name;
  final String email;
  final String photourl;
  final String rate;
  final bool isTested;
  final String addtime;

  const UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.photourl,
      required this.rate,
      required this.isTested,
      required this.addtime});

  @override
  List<Object?> get props =>
      [id, name, email, photourl,isTested, rate, addtime];
}
