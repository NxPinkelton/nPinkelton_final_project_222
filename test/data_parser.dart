import 'package:nPinkelton_final_project_222/data_parser.dart';
import 'package:test/test.dart';
import 'dart:io';

const _testPuuid = 'nvPdRr7ZMzx5uMWQ9Wj90K5KtekgFysWazHv6BTXScrt-5lDO6YXI-VzBpSkQT7q01aw-hq63nOR2A';

void main() {
  late String playerData;
  late DataParser parser;

  setUp(() async {
    playerData = await File('test/sample_data.json').readAsString();
    parser = DataParser();
  });

  test('Finds the participant record matching the given puuid', () {
    final player = parser.playerByPuuid(playerData, puuid: _testPuuid);
    expect(player, isNotNull);
    expect(player!.puuid, equals(_testPuuid));
  });

  test("Parses the player's champion info from match data", () {
    final player = parser.playerByPuuid(playerData, puuid: _testPuuid);
    expect(player, isNotNull);
    expect(player!.championName, equals('Ornn'));
    expect(player.championLevel, equals(14));
    expect(player.championExperience, equals(12569));
  });

  test("Parses the player's in-game statistics from match data", () {
    final player = parser.playerByPuuid(playerData, puuid: _testPuuid);
    expect(player, isNotNull);
    expect(player!.kills, equals(1));
    expect(player.deaths, equals(3));
    expect(player.damagePerMinute, closeTo(347.0953, 0.0001));
    expect(player.kda, closeTo(0.6667, 0.0001));
  });
}