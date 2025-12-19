import 'package:flutter/material.dart';

class NewRecordPage extends StatefulWidget {
  const NewRecordPage({super.key});

  @override
  State<NewRecordPage> createState() => _NewRecordPageState();
}

class _NewRecordPageState extends State<NewRecordPage> {
  final _thoughtController = TextEditingController();
  final _emotionController = TextEditingController();
  double _intensity = 5;

  @override
  void dispose() {
    _thoughtController.dispose();
    _emotionController.dispose();
    super.dispose();
  }

  void _save() {
    final thought = _thoughtController.text.trim();
    final emotion = _emotionController.text.trim();

    if (thought.isEmpty || emotion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preenche pensamento e emoção.')),
      );
      return;
    }

    // Por enquanto, só voltamos com os dados.
    Navigator.pop(context, {
      'thought': thought,
      'emotion': emotion,
      'intensity': _intensity.round(),
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pensamento', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _thoughtController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ex: Vou falhar na reunião.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Emoção', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _emotionController,
              decoration: const InputDecoration(
                hintText: 'Ex: Ansiedade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Intensidade: ${_intensity.round()}/10',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _intensity,
              min: 0,
              max: 10,
              divisions: 10,
              label: _intensity.round().toString(),
              onChanged: (v) => setState(() => _intensity = v),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
