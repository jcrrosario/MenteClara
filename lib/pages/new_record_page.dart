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
  static const _bg = Color(0xFFF6F7F9);
  static const _teal = Color(0xFF00B894);
  static const _teal2 = Color(0xFF0AAEAB);

  final _thoughtController = TextEditingController();
  final _thoughtAltController = TextEditingController();
  final _emotionController = TextEditingController();
  final _behaviorController = TextEditingController();

  double _intensity = 5;

  final List<String> _emotionSuggestions = const [
    'Ansiedade',
    'Tristeza',
    'Raiva',
    'Medo',
    'Culpa',
    'Vergonha',
    'Frustração',
    'Alegria',
    'Alívio',
  ];

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
    final isEdit = widget.record != null;

    return Scaffold(
      backgroundColor: _bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(isEdit ? 'Edição' : 'Novo registro RPD'),
      ),

      // ✅ Coloca o botão em bottomNavigationBar.
      // O Scaffold já empurra isso acima do teclado quando resizeToAvoidBottomInset=true.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text(isEdit ? 'Salvar alterações' : 'Salvar registro'),
            ),
          ),
        ),
      ),

      // ✅ Body é um ListView, então nunca estoura quando o teclado sobe.
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            _sectionCard(
              title: 'Situação',
              subtitle: 'O que aconteceu, onde, com quem.',
              icon: Icons.place_outlined,
              child: TextField(
                controller: _thoughtController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Descreva a situação com clareza',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _sectionCard(
              title: 'Pensamento automático',
              subtitle: 'O que passou pela sua cabeça.',
              icon: Icons.psychology_alt_outlined,
              child: TextField(
                controller: _thoughtAltController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ex: "Vou falhar", "Não sou bom o suficiente"...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _sectionCard(
              title: 'Emoção',
              subtitle: 'Escolha uma sugestão ou escreva.',
              icon: Icons.sentiment_satisfied_alt,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _emotionSuggestions.map((e) {
                      final selected =
                          _emotionController.text.trim().toLowerCase() ==
                              e.toLowerCase();

                      return ChoiceChip(
                        label: Text(e),
                        selected: selected,
                        selectedColor: _teal2.withOpacity(.18),
                        onSelected: (_) =>
                            setState(() => _emotionController.text = e),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: selected ? _teal2 : Colors.black87,
                        ),
                        side: BorderSide(color: _teal2.withOpacity(.25)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emotionController,
                    decoration: const InputDecoration(
                      hintText: 'Ou escreva aqui, ex: ansiedade, medo, raiva',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _sectionCard(
              title: 'O que você fez',
              subtitle: 'Comportamento ou reação.',
              icon: Icons.directions_run_outlined,
              child: TextField(
                controller: _behaviorController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ex: evitei, conversei, respirei fundo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _sectionCard(
              title: 'Intensidade',
              subtitle: 'Quanto isso pegou em você agora.',
              icon: Icons.local_fire_department_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${_intensity.round()}/10',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: _intensity / 10.0,
                            minHeight: 10,
                            backgroundColor: Colors.black.withOpacity(.06),
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(_teal2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _teal2,
                      inactiveTrackColor: _teal2.withOpacity(.20),
                      thumbColor: _teal,
                      overlayColor: _teal.withOpacity(.18),
                    ),
                    child: Slider(
                      value: _intensity,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: _intensity.round().toString(),
                      onChanged: (v) => setState(() => _intensity = v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: _teal2.withOpacity(.12),
                  child: Icon(icon, size: 18, color: _teal2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
