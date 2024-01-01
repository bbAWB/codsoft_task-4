import 'package:flutter/material.dart';

import 'package:quiz/services/database.dart';
import 'package:quiz/view/DisplayQuiz.dart';

import 'create_quiz.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? quizSteam;
  DatabaseService service = DatabaseService();
  Widget quizList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      child: StreamBuilder(
        stream: quizSteam,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return QuizTitle(
                      imgUrl: snapshot.data.docs[index].data()["quizImgurl"],
                      title:
                          snapshot.data.docs[index].data()["quizDescription"],
                      desc: snapshot.data.docs[index].data()["quizTitle"],
                      quizid: snapshot.data.docs[index].data()["quizId"],
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    service.getQuizData().then((val) {
      setState(() {
        quizSteam = val;
      });
    });
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
                top: height * 0.09),
            child: Row(
              children: [
                Image(
                  image: const AssetImage('assets/quiz.png'),
                  height: height * 0.04,
                ),
                Container(
                  child: RichText(
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
                ),
                const Spacer(),
              ],
            )),
      ),
      body: quizList(),
      backgroundColor: const Color.fromARGB(255, 222, 240, 238),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatQuiz()));
        },
      ),
    );
  }
}

class QuizTitle extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizid;
  QuizTitle(
      {required this.imgUrl,
      required this.desc,
      required this.title,
      required this.quizid});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayQuiz(
                      quizid,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.7,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.7,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
