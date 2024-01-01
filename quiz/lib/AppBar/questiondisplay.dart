import 'package:flutter/material.dart';

class Options extends StatefulWidget {
  final String option, desc, correctAnswer, optionSelected;

  Options(
      {required this.desc,
      required this.correctAnswer,
      required this.option,
      required this.optionSelected});

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              height: 28,
              width: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.optionSelected == widget.desc
                          ? widget.desc == widget.correctAnswer
                              ? Colors.green.withOpacity(0.7)
                              : Colors.red.withOpacity(0.7)
                          : Colors.grey,
                      width: 1.5),
                  color: widget.optionSelected == widget.desc
                      ? widget.desc == widget.correctAnswer
                          ? Colors.green.withOpacity(0.7)
                          : Colors.red.withOpacity(0.7)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                widget.option,
                style: TextStyle(
                  color: widget.optionSelected == widget.desc
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              widget.desc,
              style: TextStyle(fontSize: 17, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class NoOfQuestion extends StatefulWidget {
  final String text;
  final int number;
  const NoOfQuestion({super.key, required this.number, required this.text});

  @override
  State<NoOfQuestion> createState() => _NoOfQuestionState();
}

class _NoOfQuestionState extends State<NoOfQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
            color: Colors.blue,
          ),
          child: Text(
            "${widget.number}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14)),
              color: Colors.blue),
          child: Text(
            "${widget.number}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14)),
              color: Colors.black54),
          child: Text(
            widget.text,
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    );
  }
}
