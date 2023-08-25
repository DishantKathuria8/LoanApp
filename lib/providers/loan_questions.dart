import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:questionare_bank/models/questionnaire.dart';

class LoanQuestionsProvider extends ChangeNotifier {
  Questionnaire? questions;

  int currentQuestionIndex = 0;

  String firstAnswer = '';

  String secondAnswer = '';

  String fourthAnswer = '';

  bool isAnswered = false;

  String fifthAnswer_1 = '';

  String fifthAnswer_2 = '';

  var totalIncomeController = TextEditingController();

  Future<String> loadQuestionnaire() async {
    String jsonString = await rootBundle.loadString('assets/questions.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);
    questions = Questionnaire.fromJson(jsonData);
    return "success";
  }

  callNotify() {
    notifyListeners();
  }
}
