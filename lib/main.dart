import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:questionare_bank/providers/loan_questions.dart';
import 'package:questionare_bank/screens/loan_questions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoanQuestionsProvider()),
      ],
      child: MaterialApp(
        title: 'Loan App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoanQuestions(),
      ),
    );
  }
}
