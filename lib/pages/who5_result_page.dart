import 'package:flutter/material.dart';

class Who5ResultPage extends StatelessWidget {
  final int score;

  const Who5ResultPage({super.key, required this.score});

  String get interpretation {
    if (score >= 51) {
      return 'Seu bem-estar emocional está preservado.';
    } else if (score >= 29) {
      return 'Atenção. Pode haver desgaste emocional.';
    } else {
      return 'Sinal de sofrimento emocional importante.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Pontuação WHO-5',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              '$score / 100',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              interpretation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: const Text('Voltar para início'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
