import 'package:flutter/material.dart';

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({super.key});

  @override
  State<DailyCheckInPage> createState() => _DailyCheckInPageState();
}

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  int selectedMood = 2;
  final Set<String> selectedFeelings = {};
  final noteController = TextEditingController();

  final moods = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  final feelings = [
    'Otimista',
    'Cansado',
    'Focado',
    'Ansioso',
    'Grato',
    'Irritado',
    'Motivado',
    'Triste',
    'Calmo',
    'Estressado',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Diário'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Como você está se sentindo?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Tire um momento para se conectar consigo mesmo.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Meu humor geral',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(moods.length, (index) {
                    final selected = index == selectedMood;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMood = index),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF0FA58E).withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF0FA58E)
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          moods[index],
                          size: 32,
                          color: selected
                              ? const Color(0xFF0FA58E)
                              : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Estou me sentindo...',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: feelings.map((f) {
                    final selected = selectedFeelings.contains(f);
                    return ChoiceChip(
                      label: Text(f),
                      selected: selected,
                      selectedColor: const Color(0xFF0FA58E),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                      ),
                      onSelected: (v) {
                        setState(() {
                          v
                              ? selectedFeelings.add(f)
                              : selectedFeelings.remove(f);
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Alguma nota sobre hoje?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Escreva brevemente...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Check-in'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0FA58E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
