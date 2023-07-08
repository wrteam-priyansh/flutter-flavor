import 'package:flavour_demo/data/models/option.dart';

class Question {
  final String question;
  final String imageUrl;
  final String audioUrl;
  final int id;
  final List<Option> options;

  Question(
      {required this.audioUrl,
      required this.id,
      required this.imageUrl,
      required this.options,
      required this.question});

  List<int> getCorrectAnswerOptionIds() {
    return getCorrectAnswerOptions().map((e) => e.id).toList();
  }

  List<Option> getCorrectAnswerOptions() {
    return options.where((element) => element.isAnswer).toList();
  }

  int correctAnswerLength() {
    return getCorrectAnswerOptions().length;
  }
}
