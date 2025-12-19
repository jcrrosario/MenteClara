import 'package:flutter/material.dart';

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
        onPressed: () {
          // depois vamos abrir a tela de cadastro
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
