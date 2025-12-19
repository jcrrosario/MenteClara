import 'package:flutter/material.dart';
import 'new_record_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mente Clara'),
      ),
      body: const Center(
        child: Text(
          'Nenhum registro ainda',
          style: TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // tela de novo registro
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewRecordPage()),
          );

          if (result != null) {
            // Por enquanto só mostra um feedback.
            // No próximo passo a gente vai exibir numa lista na Home.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registro salvo.')),
            );
          }

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
