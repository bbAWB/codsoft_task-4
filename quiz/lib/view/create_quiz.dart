import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/AppBar/appbar.dart';
import 'package:quiz/services/database.dart';
import 'package:quiz/view/addquestion.dart';
import 'package:random_string/random_string.dart';

class CreatQuiz extends StatefulWidget {
  const CreatQuiz({super.key});

  @override
  State<CreatQuiz> createState() => _CreatQuizState();
}

class _CreatQuizState extends State<CreatQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl = '', quizTitle = '', quizDesc = '', quizId = '';
  DatabaseService databaseService = DatabaseService();
  bool _isLoading = false;
  createQuiz() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(16);
      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgurl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDesc
      };
      await databaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddQuestions(quizId)));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black87),
          systemOverlayStyle: SystemUiOverlayStyle.light),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  TextFormField(
                    validator: (val) => val!.isEmpty ? "Enter Image Url" : null,
                    decoration: const InputDecoration(
                      hintText: "Quiz Image URL",
                    ),
                    onChanged: (val) {
                      quizImageUrl = val;
                    },
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Enter Quiz Title" : null,
                    decoration: const InputDecoration(
                      hintText: "Enter Quiz Title",
                    ),
                    onChanged: (val) {
                      quizTitle = val;
                    },
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? "Enter Quiz Description" : null,
                    decoration: const InputDecoration(
                      hintText: "Enter Quiz Description",
                    ),
                    onChanged: (val) {
                      quizDesc = val;
                    },
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        createQuiz();
                      },
                      child:
                          redButtton(context: context, lable: "Create  Quiz")),
                  const SizedBox(height: 60),
                ]),
              ),
            ),
      backgroundColor: const Color.fromARGB(255, 222, 240, 238),
    );
  }
}
