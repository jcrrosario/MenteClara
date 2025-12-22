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
  static const _bg = Color(0xFFF6F7F9);
  static const _teal = Color(0xFF00B894);
  static const _teal2 = Color(0xFF0AAEAB);

  final AppDatabase _db = AppDatabase();

  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }

  bool _hasText(String? v) => v != null && v.trim().isNotEmpty;

  Future<void> _onEditPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewRecordPage(record: widget.record)),
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
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Consulta de RPD'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _onEditPressed,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _summaryCard(),
          const SizedBox(height: 14),
          _sectionCard(title: 'Situação', icon: Icons.place_outlined, text: widget.record.thought),
          if (_hasText(widget.record.thoughtAlt)) ...[
            const SizedBox(height: 12),
            _sectionCard(
              title: 'Pensamento automático',
              icon: Icons.psychology_alt_outlined,
              text: widget.record.thoughtAlt!.trim(),
            ),
          ],
          if (_hasText(widget.record.behavior)) ...[
            const SizedBox(height: 12),
            _sectionCard(
              title: 'O que você fez',
              icon: Icons.directions_run_outlined,
              text: widget.record.behavior!.trim(),
            ),
          ],
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Data',
            icon: Icons.calendar_month_outlined,
            text: _formatDate(widget.record.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    final intensity = widget.record.intensity.clamp(0, 10);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_teal, _teal2],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sentiment_satisfied_alt, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.record.emotion,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$intensity/10',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: intensity / 10.0,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(.20),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(.92)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatDate(widget.record.createdAt),
            style: TextStyle(color: Colors.white.withOpacity(.85)),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required String text}) {
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 10),
            Text(text, style: const TextStyle(fontSize: 15, height: 1.35)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
