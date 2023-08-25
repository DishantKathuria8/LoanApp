import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionare_bank/providers/loan_questions.dart';

class ReviewAnswers extends StatefulWidget {
  const ReviewAnswers({Key? key}) : super(key: key);

  @override
  State<ReviewAnswers> createState() => _ReviewAnswersState();
}

class _ReviewAnswersState extends State<ReviewAnswers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<LoanQuestionsProvider>(
            builder: (_, questionProvider, child) => Padding(
                  padding: EdgeInsets.fromLTRB(16, 60, 16, 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Review Your Answers",
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              questionProvider.questions?.schema.fields.length,
                          itemBuilder: (context, index) {
                            return buildQuesAns(
                                context,
                                index,
                                questionProvider
                                    .questions?.schema.fields[index].schema);
                          })
                    ],
                  ),
                )));
  }

  Widget buildQuesAns(BuildContext context, int index, var data) {
    var questionProvider =
        Provider.of<LoanQuestionsProvider>(context, listen: false);
    return index == 3 &&
            questionProvider.firstAnswer == "Balance transfer & Top-up"
        ? SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["label"],
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              index != 4
                  ? Text(
                      index == 0
                          ? questionProvider.firstAnswer
                          : index == 1
                              ? questionProvider.secondAnswer
                              : index == 2
                                  ? '₹' +
                                      questionProvider
                                          .totalIncomeController.text
                                  : index == 3
                                      ? questionProvider.fourthAnswer
                                      : questionProvider.fifthAnswer_1,
                      style: TextStyle(fontSize: 13.0),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              data["fields"][0]["schema"]["label"] + " : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              questionProvider.fifthAnswer_1,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              data["fields"][1]["schema"]["label"] + " : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              questionProvider.fifthAnswer_2,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        )
                      ],
                    ),
              SizedBox(
                height: 15,
              ),
            ],
          );
  }
}
