class Question {
  final String? question;
  final List<dynamic>? incorrectAnswers;

  Question({
    this.question,
    this.incorrectAnswers});

  Question.fromMap(Map<String, dynamic> data)
      : question = data["question"],
        incorrectAnswers = data["incorrect_answers"];

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}
