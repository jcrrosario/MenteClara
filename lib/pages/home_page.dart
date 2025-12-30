import 'package:flutter/material.dart';

import '../db/app_database.dart';
import '../models/record.dart';

import 'new_record_page.dart';
import 'record_detail_page.dart';
import 'records_list_page.dart';
import 'daily_checkin_page.dart';

import '../data/record_repository.dart';
import '../data/drift_record_repository.dart';
import 'who5_intro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase _db = AppDatabase();

  bool _loading = true;
  List<ThoughtRecord> _recent = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    setState(() => _loading = true);
    try {
      final all = await _db.getAllRecords();
      setState(() {
        _recent = all.take(3).toList();
      });
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

    await _loadRecent();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro salvo.')),
    );
  }

  Future<void> _openAllRecords() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecordsListPage()),
    );
    if (!mounted) return;
    await _loadRecent();
  }

  Future<void> _openDetail(ThoughtRecord record) async {
    final changed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecordDetailPage(record: record)),
    );

    if (changed == true) {
      await _loadRecent();
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _loadRecent,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${_greeting()}, pessoa',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Vamos trazer clareza para sua mente hoje?',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              _checkinCard(),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      icon: Icons.edit_note,
                      title: 'Registro (RPD)',
                      subtitle:
                      'Anote registros de pensamentos disfuncionais',
                      onTap: _openNewRecord,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionCard(
                      icon: Icons.monitor_heart_outlined,
                      title: 'Autoavaliação',
                      subtitle: 'Teste de avaliação WHO-5',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Who5IntroPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Últimos Registros - RPD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: _openAllRecords,
                    child: const Text('Ver tudo'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              _recentSection(),

              const SizedBox(height: 20),

              _tipOfDay(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkinCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00B894),
            Color(0xFF0AAEAB),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart_outlined, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Check-in Diário',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0AAEAB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DailyCheckInPage(),
                    ),
                  );
                },
                child: const Text(
                  'Registrar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Como você está se sentindo agora?',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              _MoodDot('😟'),
              SizedBox(width: 10),
              _MoodDot('😐'),
              SizedBox(width: 10),
              _MoodDot('🙂'),
              SizedBox(width: 10),
              _MoodDot('😄'),
              SizedBox(width: 10),
              _MoodDot('😃'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black.withOpacity(0.04),
              child: Icon(icon, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style:
              const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentSection() {
    if (_recent.isEmpty) {
      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _openNewRecord,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black12),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Nenhum pensamento registrado ainda.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                'Começar agora',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _openAllRecords,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            for (int i = 0; i < _recent.length; i++) ...[
              ListTile(
                onTap: () => _openDetail(_recent[i]),
                title: Text(
                  _recent[i].thought,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${_recent[i].emotion} • ${_recent[i].intensity}/10',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              if (i != _recent.length - 1)
                const Divider(height: 1, thickness: 0.5),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tipOfDay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF00B894), // VERDE DO APP
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withOpacity(0.18),
            child:
            const Icon(Icons.announcement_outlined, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desenvolvido por: Serenyo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tecnologia feita para o que você sente',
                  style:
                  TextStyle(color: Colors.white70, height: 1.3),
                ),
              ],
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

class _MoodDot extends StatelessWidget {
  final String emoji;
  const _MoodDot(this.emoji);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white.withOpacity(0.18),
      child: Text(emoji, style: const TextStyle(fontSize: 16)),
    );
  }
}
