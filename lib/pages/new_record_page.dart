import 'package:flutter/material.dart';
import '../db/app_database.dart';

class NewRecordPage extends StatefulWidget {
  final ThoughtRecord? record;

  const NewRecordPage({
    super.key,
    this.record,
  });
  @override
  State<NewRecordPage> createState() => _NewRecordPageState();
}

class _NewRecordPageState extends State<NewRecordPage> {
  final _thoughtController = TextEditingController();
  final _thoughtAltController = TextEditingController();
  final _emotionController = TextEditingController();
  final _behaviorController = TextEditingController();

  double _intensity = 5;

  @override
  void initState() {
    super.initState();

    final r = widget.record;
    if (r != null) {
      _thoughtController.text = r.thought;
      _thoughtAltController.text = (r.thoughtAlt ?? '');
      _emotionController.text = r.emotion;
      _behaviorController.text = (r.behavior ?? '');
      _intensity = r.intensity.toDouble();
    }
  }


  @override
  void dispose() {
    _thoughtController.dispose();
    _thoughtAltController.dispose();
    _emotionController.dispose();
    _behaviorController.dispose();
    super.dispose();
  }

  void _save() {
    final thought = _thoughtController.text.trim();
    final emotion = _emotionController.text.trim();

    if (thought.isEmpty || emotion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pensamento e emoção são obrigatórios')),
      );
      return;
    }

    Navigator.pop(context, {
      'id': widget.record?.id,
      'isEdit': widget.record != null,

      'thought': thought,
      'thoughtAlt': _thoughtAltController.text.trim().isEmpty
          ? null
          : _thoughtAltController.text.trim(),
      'emotion': emotion,
      'behavior': _behaviorController.text.trim().isEmpty
          ? null
          : _behaviorController.text.trim(),
      'intensity': _intensity.round(),
      'createdAt': (widget.record?.createdAt ?? DateTime.now()).toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.record == null ? 'Novo registro' : 'Editar registro'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A Situação', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _thoughtController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'O que aconteceu? Onde você estava? Quem estava com você?',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              const Text('O Pensamento', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _thoughtAltController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'O que passou pela sua cabeça? (Pensamento Automático)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              const Text('Emoção', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _emotionController,
                decoration: const InputDecoration(
                  hintText: 'Ex: ansiedade, medo, raiva',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              const Text('O que você fez? (comportamento)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _behaviorController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ex: evitei, conversei, respirei fundo',
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
