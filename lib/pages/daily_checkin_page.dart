import 'package:flutter/material.dart';

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({super.key});

  @override
  State<DailyCheckInPage> createState() => _DailyCheckInPageState();
}

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  String? _selectedMood;
  double _intensity = 5;
  final TextEditingController _noteController = TextEditingController();

  final List<String> _moods = ['😟', '😐', '🙂', '😄', '😃'];

  void _saveCheckIn() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione como você está se sentindo.'),
        ),
      );
      return;
    }

    // Por enquanto só volta para a Home
    // Depois você pode salvar no banco tranquilamente
    Navigator.pop(context, {
      'mood': _selectedMood,
      'intensity': _intensity.round(),
      'note': _noteController.text,
      'date': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Diário'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Como você está se sentindo hoje?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moods.map((mood) {
                final selected = mood == _selectedMood;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: selected
                        ? const Color(0xFF00B894)
                        : Colors.black.withOpacity(0.05),
                    child: Text(
                      mood,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Intensidade',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_intensity.round()}/10',
              style: const TextStyle(color: Colors.black54),
            ),

            Slider(
              value: _intensity,
              min: 0,
              max: 10,
              divisions: 10,
              activeColor: const Color(0xFF00B894),
              label: _intensity.round().toString(),
              onChanged: (value) {
                setState(() {
                  _intensity = value;
                });
              },
            ),

            const SizedBox(height: 16),

            const Text(
              'Quer deixar uma observação?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escreva livremente, se quiser...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B894),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveCheckIn,
                child: const Text(
                  'Salvar check-in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
