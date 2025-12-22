import 'package:flutter/material.dart';

class DailyCheckInPage extends StatelessWidget {
  const DailyCheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Diário'),
      ),
      body: const Center(
        child: Text(
          'Tela de Check-in Diário',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
