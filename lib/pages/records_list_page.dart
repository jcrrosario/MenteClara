import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/app_database.dart';
import 'new_record_page.dart';
import 'record_detail_page.dart';

// PDF
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  final DateFormat _df = DateFormat('dd/MM/yyyy HH:mm');

  bool _loading = true;
  List<ThoughtRecord> _records = [];
  List<ThoughtRecord> _filtered = [];

  // filtros
  String? _emotionFilter;
  int? _intensityFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final data = await _db.getAllRecords();
    if (!mounted) return;
    setState(() {
      _records = data;
      _filtered = List.from(data);
      _loading = false;
    });
  }

  // =========================
  // FILTROS
  // =========================
  void _applyFilters() {
    setState(() {
      _filtered = _records.where((r) {
        final byEmotion =
            _emotionFilter == null || r.emotion == _emotionFilter;
        final byIntensity =
            _intensityFilter == null || r.intensity == _intensityFilter;
        final byStart =
            _startDate == null || !r.createdAt.isBefore(_startDate!);
        final byEnd =
            _endDate == null || !r.createdAt.isAfter(_endDate!);

        return byEmotion && byIntensity && byStart && byEnd;
      }).toList();
    });
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                runSpacing: 16,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),

                  // Emoção
                  DropdownButtonFormField<String>(
                    value: _emotionFilter,
                    decoration: const InputDecoration(labelText: 'Emoção'),
                    items: _records
                        .map((e) => e.emotion)
                        .toSet()
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                        .toList(),
                    onChanged: (v) => setModal(() => _emotionFilter = v),
                  ),

                  // Intensidade
                  DropdownButtonFormField<int>(
                    value: _intensityFilter,
                    decoration: const InputDecoration(labelText: 'Intensidade'),
                    items: List.generate(
                      10,
                          (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('${i + 1}'),
                      ),
                    ),
                    onChanged: (v) => setModal(() => _intensityFilter = v),
                  ),

                  // Data inicial
                  ListTile(
                    title: Text(
                      _startDate == null
                          ? 'Data inicial'
                          : 'Início: ${DateFormat('dd/MM/yyyy').format(_startDate!)}',
                    ),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      if (d != null) setModal(() => _startDate = d);
                    },
                  ),

                  // Data final
                  ListTile(
                    title: Text(
                      _endDate == null
                          ? 'Data final'
                          : 'Fim: ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                    ),
                    trailing: const Icon(Icons.date_range),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      if (d != null) setModal(() => _endDate = d);
                    },
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _emotionFilter = null;
                              _intensityFilter = null;
                              _startDate = null;
                              _endDate = null;
                              _filtered = List.from(_records);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Limpar'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _applyFilters();
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

  // =========================
  // PDF
  // =========================
  Future<void> _exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Text(
            'Relatório de Registros RPD',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Gerado em ${_df.format(DateTime.now())}'),
          pw.SizedBox(height: 16),

          ..._filtered.map(
                (r) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 12),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(_df.format(r.createdAt),
                      style: pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 6),

                  pw.Text('Situação',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(r.thought),

                  pw.SizedBox(height: 6),
                  pw.Text('Pensamento',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(r.thoughtAlt ?? '-'),

                  pw.SizedBox(height: 6),
                  pw.Text('Emoção',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(r.emotion),

                  pw.SizedBox(height: 6),
                  pw.Text('O que você fez',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(r.behavior ?? '-'),

                  pw.SizedBox(height: 6),
                  pw.Text('Intensidade',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('${r.intensity}/10'),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  // =========================
  // UI
  // =========================
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
                  : _list(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
              'Registros RPD',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _openFilterModal,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _exportPdf,
          ),
        ],
      ),
    );
  }

  Widget _list() {
    if (_filtered.isEmpty) {
      return const Center(child: Text('Nenhum registro encontrado'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      itemBuilder: (_, i) {
        final r = _filtered[i];

        return Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: _teal2.withOpacity(.12),
                  child: const Icon(Icons.notes, color: _teal2),
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
                      const SizedBox(height: 6),
                      Text('${r.emotion} • ${r.intensity}/10'),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: _teal2),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewRecordPage(record: r),
                          ),
                        );
                        _loadRecords();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await _db.deleteRecordById(r.id);
                        _loadRecords();
                      },
                    ),
                  ],
                ),
              ],
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
