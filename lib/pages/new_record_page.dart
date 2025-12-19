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

    Navigator.pop(context, {
      'thought': thought,
      'emotion': emotion,
      'intensity': _intensity.round(),
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Novo registro'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pensamento', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _thoughtController,
                maxLines: 3,
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.done,
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

              const SizedBox(height: 24),

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
      ),
    );
  }
}
