import 'package:flutter/material.dart';
import '../db/app_database.dart';
import 'new_record_page.dart';

class RecordDetailPage extends StatefulWidget {
  final ThoughtRecord record;

  const RecordDetailPage({
    super.key,
    required this.record,
  });

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  final AppDatabase _db = AppDatabase();
  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }

  bool _hasText(String? v) => v != null && v.trim().isNotEmpty;


  Future<void> _onEditPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewRecordPage(record: widget.record),
      ),
    );

    if (result == null) return;

    await _db.updateRecordById(
      id: widget.record.id,
      thought: result['thought'] as String,
      thoughtAlt: result['thoughtAlt'] as String?,
      emotion: result['emotion'] as String,
      behavior: result['behavior'] as String?,
      intensity: result['intensity'] as int,
      createdAt: widget.record.createdAt,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do registro'),
        actions: [
          IconButton(
            tooltip: 'Editar registro',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _onEditPressed,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle('Emoção'),
            const SizedBox(height: 8),
            _cardText(widget.record.emotion),

            const SizedBox(height: 16),

            _sectionTitle('Intensidade'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${widget.record.intensity}/10',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: widget.record.intensity / 10.0,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _sectionTitle('Situação'),
            const SizedBox(height: 8),
            _cardText(widget.record.thought),

            if (_hasText(widget.record.thoughtAlt)) ...[
              const SizedBox(height: 16),
              _sectionTitle('O Pensamento'),
              const SizedBox(height: 8),
              _cardText(widget.record.thoughtAlt!.trim()),
            ],

            if (_hasText(widget.record.behavior)) ...[
              const SizedBox(height: 16),
              _sectionTitle('O que você fez?'),
              const SizedBox(height: 8),
              _cardText(widget.record.behavior!.trim()),
            ],

            const SizedBox(height: 16),

            _sectionTitle('Data'),
            const SizedBox(height: 8),
            _cardText(_formatDate(widget.record.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _cardText(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12.withOpacity(0.05),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

}
