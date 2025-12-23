import 'package:flutter/material.dart';
import 'who5_result_page.dart';

class Who5TestPage extends StatefulWidget {
  const Who5TestPage({super.key});

  @override
  State<Who5TestPage> createState() => _Who5TestPageState();
}

class _Who5TestPageState extends State<Who5TestPage> {
  final List<String> questions = [
    'Senti-me bem e de bom humor',
    'Senti-me calmo e relaxado',
    'Senti-me ativo e com energia',
    'Acordei sentindo-me descansado',
    'Meu dia a dia teve coisas que me interessaram',
  ];

  final Map<int, int> answers = {};

  final List<String> scale = [
    'Nunca',
    'Raramente',
    'Às vezes',
    'Frequentemente',
    'Quase sempre',
    'Sempre',
  ];

  void _finish() {
    if (answers.length < questions.length) return;
    final score = answers.values.reduce((a, b) => a + b) * 4;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Who5ResultPage(score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Avaliação'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: questions.length + 1,
        itemBuilder: (context, index) {
          if (index == questions.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B894),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: answers.length == questions.length ? _finish : null,
                child: const Text(
                  'Ver resultado',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questions[index],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: List.generate(6, (value) {
                    final selected = answers[index] == value;
                    return ChoiceChip(
                      label: Text(scale[value]),
                      selected: selected,
                      selectedColor: const Color(0xFF00B894),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                      ),
                      onSelected: (_) {
                        setState(() {
                          answers[index] = value;
                        });
                      },
                    );
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
