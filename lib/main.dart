import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'esports_services.dart';
import 'data_parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(() {
    HttpOverrides.global = _DevHttpOverrides();
    return true;
  }());
  await dotenv.load(fileName: '.env');
  runApp(const MaterialApp(home: EligibilityScreen()));
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  final _usernameController = TextEditingController();
  final _tagController = TextEditingController();
  final _service = EsportsService();
  final _parser = DataParser();

  bool _loading = false;
  String? _message;
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? _charInfo;

  Future<void> _lookup() async {
    setState(() { _loading = true; _message = null; _stats = null; _charInfo = null; });

    try {
      final puuid = await _service.requestIdentification(
          _usernameController.text.trim(), _tagController.text.trim());
      final matchIds = await _service.requestMatchList(puuid);
      final matchData = await _service.requestMatchData(matchIds.first);
      final participant = _parser.searchForPlayerId(jsonEncode(matchData), puuid)!;

      setState(() {
        _stats = _parser.pullGameStatistics(participant);
        _charInfo = _parser.pullCharacterInfo(participant);
        _message = 'To enter the Spring Invitational, your KDA must be above 2.0.';
      });
    } catch (e) {
      setState(() => _message = 'Error: Name / Tag not found');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Eligibility')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Try it with: WombatBaby #NA2',
                style: TextStyle(color: Colors.black, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(labelText: 'Tag'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _lookup,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Search Stats'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 24),
              Text(_message!, style: const TextStyle(fontSize: 14, color: Colors.black)),
            ],
            if (_stats != null && _charInfo != null) ...[
              const SizedBox(height: 16),
              _StatRow('Champion', '${_charInfo!['championName']}'),
              _StatRow('Champion Level', '${_charInfo!['champLevel']}'),
              _StatRow('Champion XP', '${_charInfo!['champExperience']}'),
              _StatRow('Kills', '${_stats!['kills']}'),
              _StatRow('Deaths', '${_stats!['deaths']}'),
              _StatRow('KDA', (_stats!['kda'] as num).toStringAsFixed(2)),
              _StatRow('Damage / Min', (_stats!['damagePerMinute'] as num).toStringAsFixed(1)),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}