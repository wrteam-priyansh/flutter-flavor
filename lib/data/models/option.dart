class Option {
  final String option;
  final String imageUrl;
  final String audioUrl;
  final int id;
  final bool isAnswer;

  const Option(
      {required this.audioUrl,
      required this.id,
      required this.imageUrl,
      required this.isAnswer,
      required this.option});
}
