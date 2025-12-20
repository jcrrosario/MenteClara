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
  static const _bg = Color(0xFFF6F7F9);
  static const _teal = Color(0xFF00B894);
  static const _teal2 = Color(0xFF0AAEAB);

  final AppDatabase _db = AppDatabase();

  bool _loading = true;
  List<ThoughtRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
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

    try {
      await _db.insertRecord(
        thought: result['thought'] as String,
        thoughtAlt: result['thoughtAlt'] as String?,
        emotion: result['emotion'] as String,
        behavior: result['behavior'] as String?,
        intensity: result['intensity'] as int,
        createdAt: DateTime.parse(result['createdAt'] as String),
      );

      await _loadRecords();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro salvo.')),
      );
    } catch (e) {
      debugPrint('Erro ao salvar registro: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
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

    try {
      await _db.updateRecordById(
        id: id as int,
        thought: result['thought'] as String,
        thoughtAlt: result['thoughtAlt'] as String?,
        emotion: result['emotion'] as String,
        behavior: result['behavior'] as String?,
        intensity: result['intensity'] as int,
        createdAt: r.createdAt,
      );

      await _loadRecords();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro atualizado.')),
      );
    } catch (e) {
      debugPrint('Erro ao atualizar registro: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: $e')),
      );
    }
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirm) return;

    try {
      await _db.deleteRecordById(r.id);
      if (!mounted) return;
      setState(() => _records.removeWhere((x) => x.id == r.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro excluído.')),
      );
    } catch (e) {
      debugPrint('Erro ao excluir registro: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_records.isEmpty ? _emptyState() : _list()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _teal,
        onPressed: _openNewRecord,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Voltar',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Registros',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            tooltip: 'Novo registro',
            onPressed: _openNewRecord,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _teal2.withOpacity(.12),
                child: const Icon(Icons.psychology_alt_outlined, color: _teal2),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nenhum registro ainda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Crie seu primeiro registro para acompanhar seus pensamentos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _openNewRecord,
                child: const Text('Novo registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return RefreshIndicator(
      color: _teal2,
      onRefresh: _loadRecords,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        itemCount: _records.length,
        itemBuilder: (_, i) {
          final r = _records[i];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  final changed = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecordDetailPage(record: r)),
                  );

                  if (changed == true) {
                    await _loadRecords();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registro atualizado.')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: _teal2.withOpacity(.12),
                        child: const Icon(Icons.notes_outlined, color: _teal2),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.thought,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _chip(
                                  icon: Icons.sentiment_satisfied_alt,
                                  text: r.emotion,
                                  color: _teal2,
                                ),
                                _chip(
                                  icon: Icons.local_fire_department_outlined,
                                  text: '${r.intensity}/10',
                                  color: _teal,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 44,
                        child: Column(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                              padding: EdgeInsets.zero,
                              tooltip: 'Editar',
                              icon: const Icon(Icons.edit_outlined, color: _teal2),
                              onPressed: () => _editRecord(r),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                              padding: EdgeInsets.zero,
                              tooltip: 'Excluir',
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _deleteRecord(r),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _chip({required IconData icon, required String text, required Color color}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withOpacity(.10),
        border: Border.all(color: color.withOpacity(.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }
}
