import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:questionare_bank/providers/loan_questions.dart';
import 'package:questionare_bank/screens/review_answers.dart';
import 'package:questionare_bank/utils/notifier.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class LoanQuestions extends StatefulWidget {
  const LoanQuestions({Key? key}) : super(key: key);

  @override
  State<LoanQuestions> createState() => _LoanQuestionsState();
}

class _LoanQuestionsState extends State<LoanQuestions> {
  Future? getQuestions;
  @override
  void initState() {
    var questionProvider =
        Provider.of<LoanQuestionsProvider>(context, listen: false);
    getQuestions = questionProvider.loadQuestionnaire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanQuestionsProvider>(
      builder: (_, questionProvider, child) => Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null) {
              return Container();
            } else if (projectSnap.hasData) {
              String data = projectSnap.data as String;
              if (data == "success") {
                return buildBody(context);
              } else {
                return Container();
              }
            } else {
              switch (projectSnap.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                case ConnectionState.active:
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                default:
                  return Container();
              }
            }
          },
          future: getQuestions,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (questionProvider.currentQuestionIndex == 4) {
                    questionProvider.currentQuestionIndex -= 2;
                  } else if (questionProvider.currentQuestionIndex > 0) {
                    questionProvider.currentQuestionIndex--;
                  }
                  questionProvider.callNotify();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new,
                      size: 17,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Back",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              FloatingActionButton(
                elevation: 0,
                backgroundColor: Color(0xffF55D30),
                onPressed: () {
                  if (questionProvider.isAnswered &&
                      questionProvider.currentQuestionIndex == 4) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewAnswers()));
                  } else if (questionProvider.isAnswered &&
                      questionProvider.currentQuestionIndex == 2 &&
                      questionProvider.firstAnswer ==
                          "Balance transfer & Top-up") {
                    questionProvider.currentQuestionIndex += 2;
                  } else if (questionProvider.isAnswered) {
                    questionProvider.currentQuestionIndex++;
                  } else {
                    Notifier.getToastMessage("Please select the answer");
                  }
                  questionProvider.callNotify();
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Consumer<LoanQuestionsProvider>(
      builder: (_, questionProvider, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionProvider.questions?.title ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              StepProgressIndicator(
                totalSteps: 5,
                currentStep: questionProvider.currentQuestionIndex + 1,
                selectedColor: Color(0xff04b23d),
                unselectedColor: Color(0xffD3D3D3),
              ),
              SizedBox(
                height: 25,
              ),
              (questionProvider.currentQuestionIndex == 0 ||
                      questionProvider.currentQuestionIndex == 1 ||
                      questionProvider.currentQuestionIndex == 3)
                  ? buildChoiceQuestion(context)
                  : questionProvider.currentQuestionIndex == 2
                      ? buildSectionType(context)
                      : buildSection2(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChoiceQuestion(BuildContext context) {
    var provider = Provider.of<LoanQuestionsProvider>(context, listen: false);
    var data =
        provider.questions?.schema.fields[provider.currentQuestionIndex].schema;
    return Consumer<LoanQuestionsProvider>(
      builder: (_, questionProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["label"] ?? '',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          Column(
            children: List.generate(
              data["options"].length,
              (index) => InkWell(
                onTap: () {
                  if (questionProvider.currentQuestionIndex == 0) {
                    questionProvider.firstAnswer =
                        data["options"][index]["value"];
                    questionProvider.isAnswered = true;
                  } else if (questionProvider.currentQuestionIndex == 1) {
                    questionProvider.secondAnswer =
                        data["options"][index]["value"];
                    questionProvider.isAnswered = true;
                  } else if (questionProvider.currentQuestionIndex == 3) {
                    questionProvider.fourthAnswer =
                        data["options"][index]["value"];
                    questionProvider.isAnswered = true;
                  }
                  questionProvider.callNotify();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: data["options"][index]["value"] ==
                                    (questionProvider.currentQuestionIndex == 0
                                        ? questionProvider.firstAnswer
                                        : questionProvider
                                                    .currentQuestionIndex ==
                                                1
                                            ? questionProvider.secondAnswer
                                            : questionProvider.fourthAnswer)
                                ? Colors.orange.shade600
                                : Color(0xffD3D3D3))),
                    child: Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Color(0xffD3D3D3),
                          ),
                          child: Radio(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: Colors.orange.shade600,
                              value: data["options"][index]["value"],
                              groupValue: (questionProvider
                                          .currentQuestionIndex ==
                                      0
                                  ? questionProvider.firstAnswer
                                  : questionProvider.currentQuestionIndex == 1
                                      ? questionProvider.secondAnswer
                                      : questionProvider.fourthAnswer),
                              onChanged: (value) => {
                                    if (questionProvider.currentQuestionIndex ==
                                        0)
                                      {
                                        questionProvider.firstAnswer = value,
                                        questionProvider.isAnswered = true,
                                      }
                                    else if (questionProvider
                                            .currentQuestionIndex ==
                                        1)
                                      {
                                        questionProvider.secondAnswer = value,
                                        questionProvider.isAnswered = true,
                                      }
                                    else if (questionProvider
                                            .currentQuestionIndex ==
                                        3)
                                      {
                                        questionProvider.fourthAnswer = value,
                                        questionProvider.isAnswered = true
                                      },
                                    questionProvider.callNotify()
                                  }),
                        ),
                        Text(
                            '${questionProvider.questions?.schema.fields[questionProvider.currentQuestionIndex].schema["options"][index]["value"]}',
                            style: TextStyle(
                              color: data["options"][index]["value"] ==
                                      (questionProvider.currentQuestionIndex ==
                                              0
                                          ? questionProvider.firstAnswer
                                          : questionProvider
                                                      .currentQuestionIndex ==
                                                  1
                                              ? questionProvider.secondAnswer
                                              : questionProvider.fourthAnswer)
                                  ? Colors.orange.shade600
                                  : Colors.black,
                              fontSize: 15,
                              fontFamily: 'Metropolis',
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSectionType(BuildContext context) {
    var provider = Provider.of<LoanQuestionsProvider>(context, listen: false);
    var data =
        provider.questions?.schema.fields[provider.currentQuestionIndex].schema;
    return Consumer<LoanQuestionsProvider>(
      builder: (_, questionProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["label"] ?? '',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormField(data["fields"][0]["schema"]["label"],
                  questionProvider.totalIncomeController, "Enter Total Income"),
              Text(
                "*" + data["fields"][1]["schema"]["label"],
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSection2(BuildContext context) {
    var provider = Provider.of<LoanQuestionsProvider>(context, listen: false);
    var data =
        provider.questions?.schema.fields[provider.currentQuestionIndex].schema;
    return Consumer<LoanQuestionsProvider>(
      builder: (_, questionProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["label"] ?? '',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["fields"][0]["schema"]["label"],
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.0),
              Column(
                children: List.generate(
                  data["fields"][0]["schema"]["options"].length,
                  (index) => InkWell(
                    onTap: () {
                      questionProvider.fifthAnswer_1 = data["fields"][0]
                          ["schema"]["options"][index]["value"];
                      questionProvider.isAnswered = true;
                      questionProvider.callNotify();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: data["fields"][0]["schema"]["options"]
                                            [index]["value"] ==
                                        questionProvider.fifthAnswer_1
                                    ? Colors.orange.shade600
                                    : Color(0xffD3D3D3))),
                        child: Row(
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Color(0xffD3D3D3),
                              ),
                              child: Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: Colors.orange.shade600,
                                  value: data["fields"][0]["schema"]["options"]
                                      [index]["value"],
                                  groupValue: questionProvider.fifthAnswer_1,
                                  onChanged: (value) => {
                                        questionProvider.fifthAnswer_1 = value,
                                        questionProvider.isAnswered = true,
                                        questionProvider.callNotify()
                                      }),
                            ),
                            Text(
                                '${data["fields"][0]["schema"]["options"][index]["value"]}',
                                style: TextStyle(
                                  color: data["fields"][0]["schema"]["options"]
                                              [index]["value"] ==
                                          questionProvider.fifthAnswer_1
                                      ? Colors.orange.shade600
                                      : Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Metropolis',
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                data["fields"][1]["schema"]["label"],
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.0),
              Column(
                children: List.generate(
                  data["fields"][1]["schema"]["options"].length,
                  (index) => InkWell(
                    onTap: () {
                      questionProvider.fifthAnswer_2 = data["fields"][1]
                          ["schema"]["options"][index]["value"];
                      questionProvider.isAnswered = true;
                      questionProvider.callNotify();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: data["fields"][1]["schema"]["options"]
                                            [index]["value"] ==
                                        questionProvider.fifthAnswer_2
                                    ? Colors.orange.shade600
                                    : Color(0xffD3D3D3))),
                        child: Row(
                          children: [
                            Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Color(0xffD3D3D3),
                              ),
                              child: Radio(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeColor: Colors.orange.shade600,
                                  value: data["fields"][1]["schema"]["options"]
                                      [index]["value"],
                                  groupValue: questionProvider.fifthAnswer_2,
                                  onChanged: (value) => {
                                        questionProvider.fifthAnswer_2 = value,
                                        questionProvider.isAnswered = true,
                                        questionProvider.callNotify()
                                      }),
                            ),
                            Text(
                                '${data["fields"][1]["schema"]["options"][index]["value"]}',
                                style: TextStyle(
                                  color: data["fields"][1]["schema"]["options"]
                                              [index]["value"] ==
                                          questionProvider.fifthAnswer_2
                                      ? Colors.orange.shade600
                                      : Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Metropolis',
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(
      String label, TextEditingController controller, String hintText) {
    var questionProvider =
        Provider.of<LoanQuestionsProvider>(context, listen: false);
    return Wrap(
      runSpacing: 2,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14, fontFamily: 'Metropolis', color: Color(0xff979797)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Metropolis',
            ),
            onChanged: (val) {
              questionProvider.isAnswered = true;
              questionProvider.callNotify();
            },
            validator: (v) {
              if (v != null && v.isNotEmpty && v != ".") {
                var val = double.parse(v);
                if (val <= 0.0) {
                  return 'Please enter a value greater than 0';
                }
                return null;
              } else if (v == ".") {
                return 'Please enter a value greater than 0';
              }
              return null;
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
            ],
            decoration: InputDecoration(
                errorMaxLines: 3,
                prefixIcon: Align(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Text(
                      '₹',
                      style: TextStyle(
                          fontSize: 18,
                          color: controller.text.length > 0
                              ? Colors.black
                              : Color(0xffD3D3D3)),
                    )),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 30,
                ),
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                contentPadding: EdgeInsets.all(16.0),
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 16,
                    color: Color(0xffD3D3D3),
                    fontFamily: 'Metropolis'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Color(0xffD3D3D3), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.orange.shade600),
                ),
                errorStyle: TextStyle(
                  fontFamily: 'Metropolis',
                  fontSize: 13,
                )),
          ),
        ),
      ],
    );
  }
}
