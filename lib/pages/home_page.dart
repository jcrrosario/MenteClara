import 'package:flutter/material.dart';
import '../models/record.dart';
import 'new_record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Record> _records = [];

  Future<void> _openNewRecord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewRecordPage()),
    );

    if (result == null) return;

    final record = Record(
      thought: result['thought'] as String,
      emotion: result['emotion'] as String,
      intensity: result['intensity'] as int,
      createdAt: DateTime.parse(result['createdAt'] as String),
    );

    setState(() {
      _records.insert(0, record);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mente Clara'),
      ),
      body: _records.isEmpty ? _emptyState() : _list(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewRecord,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        'Nenhum registro ainda',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final r = _records[index];

        return Card(
          child: ListTile(
            title: Text(r.emotion),
            subtitle: Text(
              r.thought,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text('${r.intensity}/10'),
          ),
        );
      },
    );
  }
}
