import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return Container(
    alignment: Alignment.centerLeft,
    child: RichText(
      text: const TextSpan(style: TextStyle(fontSize: 30), children: <TextSpan>[
        TextSpan(
            text: 'Quiz',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 91, 94, 93))),
        TextSpan(
          text: 'App',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 151, 173, 114)),
        ),
      ]),
    ),
  );
}

Widget redButtton(
    {required BuildContext context, required String lable, buttonWidth}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.center,
    width: buttonWidth ?? MediaQuery.of(context).size.width - 48,
    child: Text(lable, style: TextStyle(color: Colors.white, fontSize: 12)),
  );
}
