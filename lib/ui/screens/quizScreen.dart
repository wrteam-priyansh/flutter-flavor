import 'package:flavour_demo/data/models/option.dart';
import 'package:flavour_demo/data/models/question.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final List<Question> questions = [
  Question(
      audioUrl: "",
      id: 1,
      imageUrl: "",
      options: [
        const Option(
            audioUrl: "", id: 1, imageUrl: "", isAnswer: true, option: "True"),
        const Option(
            audioUrl: "",
            id: 2,
            imageUrl: "",
            isAnswer: false,
            option: "False"),
      ],
      question: "Test quesiton"),
  Question(
      audioUrl: "",
      id: 2,
      imageUrl: "",
      options: [
        const Option(
            audioUrl: "", id: 3, imageUrl: "", isAnswer: true, option: "Yes"),
        const Option(
            audioUrl: "", id: 4, imageUrl: "", isAnswer: true, option: "100%"),
        const Option(
            audioUrl: "", id: 5, imageUrl: "", isAnswer: false, option: "Nope"),
      ],
      question:
          "Is this correct answer? Select two correct option to get the full mark (:(:"),
  Question(
      audioUrl: "",
      id: 3,
      imageUrl: "",
      options: [
        const Option(
            audioUrl: "", id: 6, imageUrl: "", isAnswer: true, option: "Yes"),
        const Option(
            audioUrl: "", id: 7, imageUrl: "", isAnswer: true, option: "100%"),
        const Option(
            audioUrl: "", id: 8, imageUrl: "", isAnswer: true, option: "Sure"),
        const Option(
            audioUrl: "", id: 9, imageUrl: "", isAnswer: false, option: "Nope"),
      ],
      question:
          "Is this ok to play quiz? Select three correct option to get the full mark (:(:"),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int correctAnswer = 0;
  int points = 0;

  final int questionDuration = 25;

  //If we need to show the result
  bool showAnswerCorrectness = true;
  //This will to show the answer
  bool _displayCorrectnessAtThisMoment = false;

  //It will contain questionId as key and value will be array of submitted optionId
  final Map<int, List<int>> _submittedAnswer = {};

  late int _currentQuestionIndex = 0;
  late final AnimationController _timerAnimationController =
      AnimationController(
          vsync: this, duration: Duration(seconds: questionDuration))
        ..addStatusListener(timerAnimationStatusListener)
        ..forward();

  late final Animation<int> _timerAnimation =
      IntTween(begin: questionDuration, end: 0)
          .animate(_timerAnimationController);

  @override
  void dispose() {
    _timerAnimationController
        .removeStatusListener(timerAnimationStatusListener);
    _timerAnimationController.dispose();
    super.dispose();
  }

  void timerAnimationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      loadNextQuestion();
    }
  }

  //
  Question getCurrentQuestion() {
    return questions[_currentQuestionIndex];
  }

  List<int> getCurrentQuestionSubmittedAnswerIds() {
    return (_submittedAnswer[getCurrentQuestion().id] ?? []);
  }

  void submitAnswer({required int optionId}) async {
    //Get the submitted current answer ids
    List<int> answerIds =
        _submittedAnswer[getCurrentQuestion().id] ?? List.from([]);
    //Update the answer ids
    answerIds.add(optionId);
    //Update submitted answer ids
    _submittedAnswer[getCurrentQuestion().id] = answerIds;
    setState(() {});

    //If submitted answer ids is same as correct answer ids
    if (answerIds.length == getCurrentQuestion().correctAnswerLength()) {
      final correctAnswerIds = getCurrentQuestion().getCorrectAnswerOptionIds();
      answerIds.sort();
      correctAnswerIds.sort();
      if (listEquals(answerIds, correctAnswerIds)) {
        correctAnswer++;
        setState(() {});
      }
      _timerAnimationController.stop();
      loadNextQuestion();
    }
  }

  void loadNextQuestion() async {
    setState(() {
      _displayCorrectnessAtThisMoment = true;
    });
    await Future.delayed(const Duration(seconds: 2));

    if (_currentQuestionIndex == (questions.length - 1)) {
      if (kDebugMode) {
        print("Result page");
      }
    } else {
      //
      _displayCorrectnessAtThisMoment = false;
      _currentQuestionIndex++;
      setState(() {});
      _timerAnimationController.forward(from: 0);
    }
  }

  Widget _buildOption({required Option option}) {
    bool answerSubmitted =
        getCurrentQuestionSubmittedAnswerIds().contains(option.id);

    Color borderColor = Colors.black;

    if (answerSubmitted) {
      if (showAnswerCorrectness) {
        if (getCurrentQuestionSubmittedAnswerIds().length ==
            getCurrentQuestion().correctAnswerLength()) {
          borderColor = getCurrentQuestion()
                  .getCorrectAnswerOptionIds()
                  .contains(option.id)
              ? Colors.green
              : Colors.red;
        } else {
          borderColor = Colors.orange;
        }
      } else {
        borderColor = Colors.orange;
      }
    } else {
      if (showAnswerCorrectness && _displayCorrectnessAtThisMoment) {
        borderColor =
            getCurrentQuestion().getCorrectAnswerOptionIds().contains(option.id)
                ? Colors.green
                : Colors.black;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () {
          if (_timerAnimationController.isCompleted) {
            return;
          }

          if (getCurrentQuestion().correctAnswerLength() ==
              getCurrentQuestionSubmittedAnswerIds().length) {
            return;
          }

          submitAnswer(optionId: option.id);
        },
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: borderColor)),
          child: Text(option.option),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              child: AnimatedBuilder(
                  animation: _timerAnimationController,
                  builder: (context, _) {
                    return Text(_timerAnimation.value.toString());
                  }),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(getCurrentQuestion().question),
                const SizedBox(
                  height: 15,
                ),
                ...getCurrentQuestion()
                    .options
                    .map((option) => _buildOption(option: option))
                    .toList()
              ],
            ),
          ))
        ],
      ),
    );
  }
}
