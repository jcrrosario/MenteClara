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
  List<ThoughtRecord> _allRecords = [];
  List<ThoughtRecord> _records = [];

  // FILTROS
  DateTime? _startDate;
  DateTime? _endDate;
  String? _emotion;
  int? _minIntensity;
  int? _maxIntensity;

  final List<String> _emotions = [
    'Tristeza',
    'Ansiedade',
    'Raiva',
    'Medo',
    'Alegria',
  ];

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
      setState(() {
        _allRecords = data;
        _applyFilters();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar registros: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    _records = _allRecords.where((r) {
      if (_emotion != null && r.emotion != _emotion) return false;
      if (_minIntensity != null && r.intensity < _minIntensity!) return false;
      if (_maxIntensity != null && r.intensity > _maxIntensity!) return false;
      if (_startDate != null && r.createdAt.isBefore(_startDate!)) return false;
      if (_endDate != null && r.createdAt.isAfter(_endDate!)) return false;
      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _emotion = null;
      _minIntensity = null;
      _maxIntensity = null;
      _records = List.from(_allRecords);
    });
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        int min = _minIntensity ?? 0;
        int max = _maxIntensity ?? 10;

        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _emotion,
                    decoration: const InputDecoration(
                      labelText: 'Emoção',
                      border: OutlineInputBorder(),
                    ),
                    items: _emotions
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setModal(() => _emotion = v),
                  ),

                  const SizedBox(height: 16),

                  Text('Intensidade: $min – $max'),
                  RangeSlider(
                    values: RangeValues(min.toDouble(), max.toDouble()),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: _teal,
                    onChanged: (v) {
                      setModal(() {
                        min = v.start.round();
                        max = v.end.round();
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _startDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (d != null) {
                              setModal(() => _startDate = d);
                            }
                          },
                          child: Text(
                            _startDate == null
                                ? 'Data inicial'
                                : 'De ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (d != null) {
                              setModal(() => _endDate = d);
                            }
                          },
                          child: Text(
                            _endDate == null
                                ? 'Data final'
                                : 'Até ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _clearFilters();
                            Navigator.pop(context);
                          },
                          child: const Text('Limpar'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: _teal),
                          onPressed: () {
                            setState(() {
                              _minIntensity = min;
                              _maxIntensity = max;
                              _applyFilters();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _editRecord(ThoughtRecord r) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewRecordPage(record: r)),
    );

    if (result == null) return;

    await _db.updateRecordById(
      id: r.id,
      thought: result['thought'],
      thoughtAlt: result['thoughtAlt'],
      emotion: result['emotion'],
      behavior: result['behavior'],
      intensity: result['intensity'],
      createdAt: r.createdAt,
    );

    await _loadRecords();
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
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    ) ??
        false;

    if (!confirm) return;

    await _db.deleteRecordById(r.id);
    await _loadRecords();
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
                  : (_records.isEmpty
                  ? const Center(child: Text('Nenhum registro encontrado'))
                  : _list()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
              'Lista de Registros RPD',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            tooltip: 'Filtrar',
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilters,
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemCount: _records.length,
      itemBuilder: (_, i) {
        final r = _records[i];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final changed = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordDetailPage(record: r),
                  ),
                );
                if (changed == true) {
                  await _loadRecords();
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
                      child:
                      const Icon(Icons.notes_outlined, color: _teal2),
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
                            style:
                            const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              _chip(
                                icon:
                                Icons.sentiment_satisfied_alt_outlined,
                                text: r.emotion,
                                color: _teal2,
                              ),
                              _chip(
                                icon:
                                Icons.local_fire_department_outlined,
                                text: '${r.intensity}/10',
                                color: _teal,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      children: [
                        IconButton(
                          tooltip: 'Editar',
                          icon: const Icon(Icons.edit_outlined,
                              color: _teal2),
                          onPressed: () => _editRecord(r),
                        ),
                        IconButton(
                          tooltip: 'Excluir',
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => _deleteRecord(r),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _chip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
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
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
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
