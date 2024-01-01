import 'package:flutter/material.dart';

class FinalResults extends StatefulWidget {
  final int correctAns, incorrectAns, totalAns;
  const FinalResults(
      {super.key,
      required this.correctAns,
      required this.incorrectAns,
      required this.totalAns});

  @override
  State<FinalResults> createState() => _FinalResultsState();
}

class _FinalResultsState extends State<FinalResults> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("${widget.correctAns}/${widget.totalAns} "),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "You Have Answerd ${widget.correctAns} Correctly And ${widget.incorrectAns} Incorrectly",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: const Text("Go to home",
                  style: TextStyle(color: Colors.white, fontSize: 19)),
            ),
          )
        ]),
      ),
    );
  }
}
