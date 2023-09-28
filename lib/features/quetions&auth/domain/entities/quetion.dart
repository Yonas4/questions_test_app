import 'package:equatable/equatable.dart';

class Quetion extends Equatable {
  final String id;
  final String question;
  final String answer;
  final List<String> options;

  const Quetion({
    required this.id,
    required this.question,
    required this.answer,
    required this.options,
  });

  @override
  List<Object?> get props => [id, question, answer, options];
}
