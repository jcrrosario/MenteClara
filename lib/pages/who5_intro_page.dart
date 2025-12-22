import 'package:flutter/material.dart';
import 'who5_test_page.dart';

class Who5IntroPage extends StatelessWidget {
  const Who5IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autoavaliação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WHO-5 – Bem-estar emocional',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Este teste avalia como você tem se sentido nas últimas duas semanas.\n\n'
                  'Não é diagnóstico. Serve para aumentar consciência emocional.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Iniciar teste'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Who5TestPage(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
