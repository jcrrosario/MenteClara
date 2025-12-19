import 'package:flutter/material.dart';
import '../db/app_database.dart';
import 'new_record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase _db = AppDatabase();

  List<ThoughtRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final data = await _db.getAllRecords();
      if (!mounted) return;

      setState(() {
        _records = data;
      });
    } catch (e) {
      debugPrint('Erro ao carregar registros: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar registros: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _openNewRecord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewRecordPage()),
    );

    if (result == null) return;

    final thought = result['thought'] as String;
    final emotion = result['emotion'] as String;
    final intensity = result['intensity'] as int;
    final createdAt = DateTime.parse(result['createdAt'] as String);

    await _db.insertRecord(
      thought: thought,
      emotion: emotion,
      intensity: intensity,
      createdAt: createdAt,
    );

    // Recarrega a lista do banco
    setState(() => _loading = true);
    await _loadRecords();

    if (!mounted) return;
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_records.isEmpty ? _emptyState() : _list()),
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

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
