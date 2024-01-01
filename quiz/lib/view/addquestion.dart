import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/AppBar/appbar.dart';
import 'package:quiz/services/database.dart';

class AddQuestions extends StatefulWidget {
  final String quizId;
  AddQuestions(this.quizId);
  @override
  State<AddQuestions> createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  final _formKey = GlobalKey<FormState>();
  String question = '', option1 = '', option2 = '', option3 = '', option4 = '';
  bool _isLoading = false;
  DatabaseService _service = DatabaseService();
  AddQuizQuestions() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> QuestionData = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      await _service.addQuestionData(QuestionData, widget.quizId).then((value) {
        setState(() {
          _isLoading = false;
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
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Question" : null,
                      decoration: const InputDecoration(
                        hintText: "Quesiton",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter Option1" : null,
                      decoration: const InputDecoration(
                        hintText: "Option1(Correct Answer)",
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter Option2" : null,
                      decoration: const InputDecoration(
                        hintText: "Option2",
                      ),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter Option3" : null,
                      decoration: const InputDecoration(
                        hintText: "Option3",
                      ),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter Option4" : null,
                      decoration: const InputDecoration(
                        hintText: "Option4",
                      ),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    const Spacer(),
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: redButtton(
                            context: context,
                            lable: "Submit",
                            buttonWidth:
                                MediaQuery.of(context).size.width / 2 - 36),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          AddQuizQuestions();
                        },
                        child: redButtton(
                            context: context,
                            lable: "Add Question",
                            buttonWidth:
                                MediaQuery.of(context).size.width / 2 - 36),
                      )
                    ]),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
