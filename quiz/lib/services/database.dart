import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData as Map<String, String>)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(Map questionData, String quizid) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizid)
        .collection("QNA")
        .add(questionData as Map<String, String>)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}
