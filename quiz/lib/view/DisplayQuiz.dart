import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz/AppBar/questiondisplay.dart';
import 'package:quiz/model/questionmodel.dart';
import 'package:quiz/services/database.dart';

import 'Result.dart';

// ignore: must_be_immutable
class DisplayQuiz extends StatefulWidget {
  final String quizId;
  DisplayQuiz(this.quizId);

  @override
  State<DisplayQuiz> createState() => _DisplayQuizState();
}

int total = 0;
int correct = 0;
int incorrect = 0;
int notAttempted = 0;
Stream? inStream;

class _DisplayQuizState extends State<DisplayQuiz> {
  DatabaseService service = DatabaseService();
  QuerySnapshot? querySnapshot;
  bool isLoading = true;
  @override
  void initState() {
    service.getQuestionData(widget.quizId).then((value) {
      querySnapshot = value;
      total = querySnapshot!.docs.length;
      notAttempted = querySnapshot!.docs.length;
      correct = 0;
      incorrect = 0;
      isLoading = false;
      setState(() {});
    });
    // ignore: prefer_conditional_assignment
    if (inStream == null) {
      // ignore: prefer_const_constructors
      inStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        // ignore: avoid_print
        print("this is x $x");
        return [correct, incorrect];
      });
    }
    super.initState();
  }

  QuestionModel questionModel(DocumentSnapshot querysnapshot) {
    final data = querysnapshot.data()! as Map<String, dynamic>;
    String option1 = data["option1"] ?? "";
    String option2 = data["option2"] ?? "";
    String option3 = data["option3"] ?? "";
    String option4 = data["option4"] ?? "";

    List<String> options = [option1, option2, option3, option4];

    options.shuffle();
    return QuestionModel(
      option1: options[0],
      option2: options[1],
      option3: options[2],
      option4: options[3],
      question: data["question"],
      correctOption: option1,
      answered: false,
    );
  }

  @override
  void dispose() {
    inStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final TextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: Container(
            padding: EdgeInsets.only(
                left: width * 0.0,
                right: width * 0.03,
                bottom: height * 0.012,
                top: height * 0.08),
            child: Row(
              children: [
                Image(
                  image: const AssetImage('assets/quiz.png'),
                  height: height * 0.04,
                ),
                RichText(
                  text: const TextSpan(
                      style: TextStyle(fontSize: 30),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Quiz',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 91, 94, 93))),
                        TextSpan(
                            text: 'App',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 151, 173, 114))),
                      ]),
                ),
                const Spacer(),
              ],
            )),
      ),
      body: isLoading
          ? Container(
              child: const Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(children: [
                  Header(length: querySnapshot!.docs.length),
                  const SizedBox(
                    height: 10,
                  ),
                  querySnapshot!.docs == null
                      ? Container(
                          child: const Center(
                            child: Text("No Data"),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: querySnapshot!.docs.length,
                          itemBuilder: (context, index) {
                            return QuizPlayTile(
                              qmodel: questionModel(querySnapshot!.docs[index]),
                              index: index,
                            );
                          },
                        ),
                  const SizedBox(
                    height: 32,
                  ),
                ]),
              ),
            ),
      backgroundColor: const Color.fromARGB(255, 222, 240, 238),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FinalResults(
                          correctAns: correct,
                          incorrectAns: incorrect,
                          totalAns: total,
                        )));
          }),
    );
  }
}

class Header extends StatefulWidget {
  final int length;
  const Header({super.key, required this.length});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: inStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestion(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestion(
                        text: "Correct",
                        number: correct,
                      ),
                      NoOfQuestion(
                        text: "Incorrect",
                        number: incorrect,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel qmodel;
  final int index;
  QuizPlayTile({required this.qmodel, required this.index});

  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionselected = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Q${widget.index + 1}) ${widget.qmodel.question}",
          style: const TextStyle(fontSize: 17, color: Colors.black87),
        ),
        const SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.qmodel.answered) {
              if (widget.qmodel.option1 == widget.qmodel.correctOption) {
                setState(() {
                  optionselected = widget.qmodel.option1;
                  widget.qmodel.answered = true;
                  correct = correct + 1;
                  notAttempted = notAttempted - 1;
                });
              } else {
                setState(() {
                  optionselected = widget.qmodel.option1;
                  widget.qmodel.answered = true;
                  incorrect = incorrect + 1;
                  notAttempted = notAttempted - 1;
                });
              }
            }
          },
          child: Options(
              correctAnswer: widget.qmodel.correctOption,
              desc: "${widget.qmodel.option1}",
              option: "A",
              optionSelected: optionselected),
        ),
        const SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.qmodel.answered) {
              if (widget.qmodel.option2 == widget.qmodel.correctOption) {
                setState(() {
                  optionselected = widget.qmodel.option2;
                  widget.qmodel.answered = true;
                  correct = correct + 1;
                  notAttempted = notAttempted - 1;
                });
              } else {
                setState(() {
                  optionselected = widget.qmodel.option2;
                  widget.qmodel.answered = true;
                  incorrect = incorrect + 1;
                  notAttempted = notAttempted - 1;
                });
              }
            }
          },
          child: Options(
              correctAnswer: widget.qmodel.correctOption,
              desc: "${widget.qmodel.option2}",
              option: "B",
              optionSelected: optionselected),
        ),
        const SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.qmodel.answered) {
              if (widget.qmodel.option3 == widget.qmodel.correctOption) {
                setState(() {
                  optionselected = widget.qmodel.option3;
                  widget.qmodel.answered = true;
                  correct = correct + 1;
                  notAttempted = notAttempted - 1;
                });
              } else {
                setState(() {
                  optionselected = widget.qmodel.option3;
                  widget.qmodel.answered = true;
                  incorrect = incorrect + 1;
                  notAttempted = notAttempted - 1;
                });
              }
            }
          },
          child: Options(
              correctAnswer: widget.qmodel.correctOption,
              desc: "${widget.qmodel.option3}",
              option: "C",
              optionSelected: optionselected),
        ),
        const SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.qmodel.answered) {
              if (widget.qmodel.option4 == widget.qmodel.correctOption) {
                setState(() {
                  optionselected = widget.qmodel.option4;
                  widget.qmodel.answered = true;
                  correct = correct + 1;
                  notAttempted = notAttempted - 1;
                });
              } else {
                setState(() {
                  optionselected = widget.qmodel.option4;
                  widget.qmodel.answered = true;
                  incorrect = incorrect + 1;
                  notAttempted = notAttempted - 1;
                });
              }
            }
          },
          child: Options(
              correctAnswer: widget.qmodel.correctOption,
              desc: "${widget.qmodel.option4}",
              option: "D",
              optionSelected: optionselected),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
