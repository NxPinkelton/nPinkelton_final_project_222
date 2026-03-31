import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nPinkelton_final_project_222/player_record.dart';
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
  final _usernameOneController = TextEditingController();
  final _tagOneController = TextEditingController();
  final _usernameTwoController = TextEditingController();
  final _tagTwoController = TextEditingController();

  final _service = EsportsService();

  bool _loading = false;
  String? _errorMessage;
  playerRecord? _playerOne;
  playerRecord? _playerTwo;

  // bool get _hasOpponentInput =>
  //     _usernameTwoController.text.trim().isNotEmpty &&
  //         _tagTwoController.text.trim().isNotEmpty;

  Future<void> _search() async {
    setState(() { _loading = true;
      _errorMessage = null;
      _playerOne = null;
      _playerTwo = null; });

    try {
      final playerOne = await _service.requestPlayerData(
        _usernameOneController.text.trim(),
        _tagOneController.text.trim(),
      );
      // final playerTwo = _hasOpponentInput
      //     ? await _service.requestPlayerData(
      //   _usernameTwoController.text.trim(),
      //   _tagTwoController.text.trim(),
      // )
      // : null;



    setState(() {
        _playerOne = playerOne
        //_playerTwo = playerTwo
      });
    } catch (e) {
      setState(() => _errorMessage = 'Error: Name / Tag not found');
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
              onPressed: _loading ? null : _search,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Search Stats'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 24),
              Text(_errorMessage!, style: const TextStyle(fontSize: 14, color: Colors.black)),
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
              ElevatedButton( //Button asking if they want to search another person up
                  onPressed: onPressed,
                  child: child)
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