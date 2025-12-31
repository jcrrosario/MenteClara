import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  final DateFormat _df = DateFormat('dd/MM/yyyy HH:mm');
  final DateFormat _dfDate = DateFormat('dd/MM/yyyy');

  bool _loading = true;
  List<ThoughtRecord> _allRecords = [];
  List<ThoughtRecord> _records = [];

  DateTime? _startDate;
  DateTime? _endDate;
  String? _emotion;
  int? _minIntensity;
  int? _maxIntensity;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    _allRecords = await _db.getAllRecords();
    _applyFilters();
    if (mounted) setState(() => _loading = false);
  }

  void _applyFilters() {
    var data = [..._allRecords];

    if (_startDate != null) {
      data = data.where((r) =>
      !r.createdAt.isBefore(_startDate!)
      ).toList();
    }

    if (_endDate != null) {
      data = data.where((r) =>
      !r.createdAt.isAfter(_endDate!.add(const Duration(days: 1)))
      ).toList();
    }

    if (_emotion != null) {
      data = data.where((r) => r.emotion == _emotion).toList();
    }

    if (_minIntensity != null) {
      data = data.where((r) => r.intensity >= _minIntensity!).toList();
    }

    if (_maxIntensity != null) {
      data = data.where((r) => r.intensity <= _maxIntensity!).toList();
    }

    setState(() => _records = data);
  }

  // ================= PDF =================

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (_) => [
          pw.Text(
            'Mente Clara',
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.teal700,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Relatório de Registros',
            style: pw.TextStyle(color: PdfColors.grey700),
          ),
          pw.Divider(),
          ..._records.map(_pdfCard),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  pw.Widget _pdfCard(ThoughtRecord r) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(_df.format(r.createdAt),
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.SizedBox(height: 6),
          pw.Text(r.thought,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('${r.emotion} • ${r.intensity}/10'),
        ],
      ),
    );
  }

  // ================= UI =================

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
                  : (_records.isEmpty ? _empty() : _list()),
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
            onPressed: _openFilter,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _records.isEmpty ? null : _generatePdf,
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return const Center(child: Text('Nenhum registro encontrado'));
  }

  Widget _list() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _records.length,
      itemBuilder: (_, i) {
        final r = _records[i];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.thought,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('${r.emotion} • ${r.intensity}/10'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: _teal2),
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
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
          ),
        );
      },
    );
  }

  // ================= FILTER =================

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _filterSheet(),
    );
  }

  Widget _filterSheet() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Filtros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),

          ListTile(
            title: Text(_startDate == null
                ? 'Data inicial'
                : _dfDate.format(_startDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDate: _startDate ?? DateTime.now(),
              );
              if (d != null) setState(() => _startDate = d);
            },
          ),

          ListTile(
            title: Text(_endDate == null
                ? 'Data final'
                : _dfDate.format(_endDate!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDate: _endDate ?? DateTime.now(),
              );
              if (d != null) setState(() => _endDate = d);
            },
          ),

          DropdownButtonFormField<String>(
            value: _emotion,
            decoration: const InputDecoration(labelText: 'Emoção'),
            items: ['Ansiedade', 'Tristeza', 'Raiva', 'Medo', 'Alegria']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => _emotion = v,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              TextButton(
                onPressed: () {
                  _startDate = null;
                  _endDate = null;
                  _emotion = null;
                  _minIntensity = null;
                  _maxIntensity = null;
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Limpar'),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _teal),
                onPressed: () {
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Aplicar'),
              ),
            ],
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
