import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nPinkelton_final_project_222/player_record.dart';
import 'esports_services.dart';

const _statLabels = [
  'Champion',
  'Champion Level',
  'Kills',
  'Deaths',
  'KDA',
  'Damage / Min',
];

var playerList = <playerRecord>[];

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

// Idea: Make a button after first person is looked up

class _EligibilityScreenState extends State<EligibilityScreen> {
  final _usernameOneController = TextEditingController();
  final _tagOneController = TextEditingController();

  final _service = EsportsService();

  bool _loading = false;
  String? _errorMessage;
  playerRecord? _playerOne;

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _playerOne = null;
    });

    try {
      final playerOne = await _service.requestPlayerData(
        _usernameOneController.text.trim(),
        _tagOneController.text.trim(),
      );

      setState(() {
        _playerOne = playerOne;
        playerList.add(_playerOne!);
      });
    } catch (e) {
      setState(() => _errorMessage = 'Error: One or both players could not be found.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _clearPlayerList() async {
    setState(() {
      playerList.clear();
    });
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
            _PlayerInputSection(
              hint: 'Try it with: WombatBaby #NA2',
              usernameController: _usernameOneController,
              tagController: _tagOneController,
            ),
            const SizedBox(height: 16),
            Text('Search for as many Players as you want'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _search,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Search Stats'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            Flexible(
              child: Row(
                children: [
                  if (playerList.isNotEmpty) ...[
                    for (int i = 0; i < playerList.length; i++) ...[
                      SizedBox(height: 24),
                      _StatsDisplay(playerOne: playerList[i])
                    ],
                  ],
                ],
              ),
            ),
            if (playerList.isNotEmpty) ...[
            ElevatedButton(
                onPressed: _clearPlayerList,
                child: _loading
                ? const CircularProgressIndicator()
                : const Text('Clear Player List')
            )],
          ],
        ),
      ),
    );
  }
}

class _PlayerInputSection extends StatelessWidget {
  final String hint;
  final TextEditingController usernameController;
  final TextEditingController tagController;
  final String usernameLabel;
  final String tagLabel;

  const _PlayerInputSection({
    required this.hint,
    required this.usernameController,
    required this.tagController,
    this.usernameLabel = 'Username',
    this.tagLabel = 'Tag',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(labelText: usernameLabel),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: tagController,
          decoration: InputDecoration(labelText: tagLabel),
        ),
      ],
    );
  }
}

class _StatsDisplay extends StatelessWidget {
  final playerRecord playerOne;
  const _StatsDisplay({required this.playerOne,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _statLabels
          .map((stat) =>
          _StatRow(
        label: stat,
        valueOne: playerOne.formattedStatRow(stat),
      ))
          .toList(),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String valueOne;

  const _StatRow({
    required this.label,
    required this.valueOne,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(valueOne, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}