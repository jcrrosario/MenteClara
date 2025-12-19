import 'package:flutter/material.dart';
import '../db/app_database.dart';

class RecordDetailPage extends StatelessWidget {
  final ThoughtRecord record;

  const RecordDetailPage({
    super.key,
    required this.record,
  });

  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}  ${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle('Emoção'),
            const SizedBox(height: 8),
            _cardText(record.emotion),

            const SizedBox(height: 16),

            _sectionTitle('Intensidade'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${record.intensity}/10',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: record.intensity / 10.0,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _sectionTitle('Pensamento'),
            const SizedBox(height: 8),
            _cardText(record.thought),

            const SizedBox(height: 16),

            _sectionTitle('Data'),
            const SizedBox(height: 8),
            _cardText(_formatDate(record.createdAt)),
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
}
