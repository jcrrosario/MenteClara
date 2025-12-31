import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  bool _loading = true;
  List<ThoughtRecord> _records = [];
  List<ThoughtRecord> _filtered = [];

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
    setState(() {
      _records = data;
      _applyFilters();
      _loading = false;
    });
  }

  void _applyFilters() {
    _filtered = _records.where((r) {
      if (_startDate != null && r.createdAt.isBefore(_startDate!)) return false;
      if (_endDate != null && r.createdAt.isAfter(_endDate!)) return false;
      return true;
    }).toList();
  }

  Future<void> _pickDate({required bool start}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (start) {
        _startDate = DateTime(picked.year, picked.month, picked.day, 0, 0);
      } else {
        _endDate = DateTime(picked.year, picked.month, picked.day, 23, 59);
      }
      _applyFilters();
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        build: (_) => [
          pw.Text(
            'Relatório de Registros RPD',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.teal800,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Gerado em ${_df.format(DateTime.now())}',
            style: pw.TextStyle(color: PdfColors.grey600),
          ),
          pw.Divider(),
          pw.SizedBox(height: 16),
          ..._filtered.map(_pdfCard),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => pdf.save());
  }

  pw.Widget _pdfCard(ThoughtRecord r) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.grey300),
        color: PdfColors.white,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _df.format(r.createdAt),
            style: pw.TextStyle(color: PdfColors.grey600, fontSize: 10),
          ),
          pw.SizedBox(height: 8),

          _pdfField('Situação', r.thought),
          _pdfField('Pensamento', r.thoughtAlt ?? '-'),
          _pdfField('Emoção', r.emotion),
          _pdfField('O que você fez', r.behavior ?? '-'),

          pw.SizedBox(height: 6),
          pw.Row(
            children: [
              pw.Text(
                'Intensidade: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text('${r.intensity}/10'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfField(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.Text(value),
        ],
      ),
    );
  }

  Future<void> _deleteRecord(ThoughtRecord r) async {
    await _db.deleteRecordById(r.id);
    await _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Registros RPD'),
        actions: [
          IconButton(
            tooltip: 'Filtrar datas',
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () async {
              await _pickDate(start: true);
              await _pickDate(start: false);
            },
          ),
          IconButton(
            tooltip: 'Gerar PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _filtered.isEmpty ? null : _generatePdf,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filtered.length,
        itemBuilder: (_, i) {
          final r = _filtered[i];
          return Card(
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text('${r.emotion} • ${r.intensity}/10'),
                        const SizedBox(height: 4),
                        Text(
                          _df.format(r.createdAt),
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: _teal2),
                        onPressed: () async {
                          final changed = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecordDetailPage(record: r),
                            ),
                          );
                          if (changed == true) _loadRecords();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => _deleteRecord(r),
                      ),
                    ],
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
