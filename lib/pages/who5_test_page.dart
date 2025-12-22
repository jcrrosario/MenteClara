import 'package:flutter/material.dart';
import '../models/who5_question.dart';
import 'who5_result_page.dart';

class Who5TestPage extends StatefulWidget {
  const Who5TestPage({super.key});

  @override
  State<Who5TestPage> createState() => _Who5TestPageState();
}

class _Who5TestPageState extends State<Who5TestPage> {
  final List<Who5Question> questions = [
    Who5Question('Senti-me bem e de bom humor'),
    Who5Question('Senti-me calmo e relaxado'),
    Who5Question('Senti-me ativo e com energia'),
    Who5Question('Acordei sentindo-me descansado'),
    Who5Question('Meu dia a dia teve coisas que me interessaram'),
  ];

  final Map<int, int> answers = {};

  final List<String> scaleLabels = [
    'Em nenhum momento',
    'Alguns momentos',
    'Menos da metade do tempo',
    'Mais da metade do tempo',
    'A maior parte do tempo',
    'O tempo todo',
  ];

  void _finishTest() {
    if (answers.length < questions.length) return;

    int rawScore = answers.values.reduce((a, b) => a + b);
    int finalScore = rawScore * 4;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Who5ResultPage(score: finalScore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WHO-5'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: answers.length == questions.length ? _finishTest : null,
                child: const Text('Ver resultado'),
              ),
            );
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questions[index].text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: List.generate(6, (value) {
                      return RadioListTile<int>(
                        title: Text(scaleLabels[value]),
                        value: value,
                        groupValue: answers[index],
                        onChanged: (v) {
                          setState(() {
                            answers[index] = v!;
                          });
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
