import 'package:flutter/material.dart';
import '../db/app_database.dart';
import 'new_record_page.dart';
import 'record_detail_page.dart';

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

  Future<bool> _confirmDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir registro'),
        content: const Text('Quer mesmo excluir este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _deleteRecord(ThoughtRecord r) async {
    await _db.deleteRecordById(r.id);

    // Atualiza a lista sem depender só do reload
    setState(() {
      _records.removeWhere((x) => x.id == r.id);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro excluído.')),
    );
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
      thoughtAlt: result['thoughtAlt'],
      emotion: emotion,
      behavior: result['behavior'],
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

        return Dismissible(
          key: ValueKey(r.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(),
          onDismissed: (_) => _deleteRecord(r),
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: ListTile(
              onTap: () async {
                final changed = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordDetailPage(record: r),
                  ),
                );
                if (changed == true) {
                  setState(() => _loading = true);
                  await _loadRecords();
                }
              },
              title: Text(
                r.emotion,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                r.thought,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${r.intensity}/10',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Excluir registro',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final ok = await _confirmDelete();
                      if (ok) {
                        await _deleteRecord(r);
                      }
                    },
                  ),
                ],
              ),
            ),
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
