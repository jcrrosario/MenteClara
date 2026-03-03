import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/app_database.dart';

class CheckInListPage extends StatefulWidget {
  const CheckInListPage({super.key});

  @override
  State<CheckInListPage> createState() => _CheckInListPageState();
}

class _CheckInListPageState extends State<CheckInListPage> {
  static const _bg = Color(0xFFF6F7F9);
  static const _teal2 = Color(0xFF0AAEAB);

  final AppDatabase _db = AppDatabase();
  final DateFormat _df = DateFormat('dd/MM/yyyy HH:mm');

  bool _loading = true;
  List<CheckInRecord> _checkins = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _db.getAllCheckIns();
    if (!mounted) return;
    setState(() {
      _checkins = data;
      _loading = false;
    });
  }

  Future<void> _delete(int id) async {
    await _db.deleteCheckInById(id);
    await _load();
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
              'Histórico de Check-in',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    if (_checkins.isEmpty) {
      return const Center(
        child: Text('Nenhum check-in registrado ainda'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _checkins.length,
      itemBuilder: (_, i) {
        final c = _checkins[i];

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _teal2.withOpacity(.12),
                  child: Text(
                    c.mood,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${c.intensity}/10',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _df.format(c.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      if (c.note != null && c.note!.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          c.note!,
                          style: const TextStyle(height: 1.3),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _delete(c.id),
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