import 'package:flutter/material.dart';
import '../db/app_database.dart';
import 'new_record_page.dart';
import 'record_detail_page.dart';

class RecordsListPage extends StatefulWidget {
  const RecordsListPage({super.key});

  @override
  State<RecordsListPage> createState() => _RecordsListPageState();
}

class _RecordsListPageState extends State<RecordsListPage> {
  final AppDatabase _db = AppDatabase();

  bool _loading = true;
  List<ThoughtRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final data = await _db.getAllRecords();
      if (!mounted) return;
      setState(() => _records = data);
    } catch (e) {
      debugPrint('Erro ao carregar registros: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar registros: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openNewRecord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NewRecordPage()),
    );

    if (result == null) return;

    await _db.insertRecord(
      thought: result['thought'],
      thoughtAlt: result['thoughtAlt'],
      emotion: result['emotion'],
      behavior: result['behavior'],
      intensity: result['intensity'],
      createdAt: DateTime.parse(result['createdAt']),
    );

    setState(() => _loading = true);
    await _loadRecords();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo.')),
    );
  }

  Future<void> _editRecord(ThoughtRecord r) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewRecordPage(record: r)),
    );

    if (result == null) return;

    final isEdit = result['isEdit'] == true;
    final id = result['id'];

    if (!isEdit || id == null) return;

    await _db.updateRecordById(
      id: id,
      thought: result['thought'],
      thoughtAlt: result['thoughtAlt'],
      emotion: result['emotion'],
      behavior: result['behavior'],
      intensity: result['intensity'],
      createdAt: DateTime.parse(result['createdAt']),
    );

    setState(() => _loading = true);
    await _loadRecords();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro atualizado.')),
    );
  }

  Future<void> _deleteRecord(ThoughtRecord r) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir registro'),
        content: const Text('Deseja realmente excluir este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirm) return;

    await _db.deleteRecordById(r.id);
    setState(() => _records.removeWhere((x) => x.id == r.id));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro excluído.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registros')),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.psychology_alt_outlined, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Nenhum registro ainda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Crie seu primeiro registro para acompanhar seus pensamentos.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _openNewRecord,
              icon: const Icon(Icons.add),
              label: const Text('Novo registro'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _loading = true);
        await _loadRecords();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final r = _records[index];

          return Card(
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
                r.thought,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${r.emotion} • Intensidade ${r.intensity}/10',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Editar',
                    onPressed: () => _editRecord(r),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Excluir',
                    onPressed: () => _deleteRecord(r),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
