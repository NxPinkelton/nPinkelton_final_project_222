import 'package:nPinkelton_final_project_222/esports_services.dart';
import 'package:test/test.dart';

void main() {
  final service = EsportsService();

  test('parses puuid from identification response', () async {
    final puuid = service.parseIdentification(
        '{"puuid":"TestId46507","gameName":"WombatBaby","tagLine":"NA2"}');
    expect(puuid, equals('TestId46507'));
  });
  test('parses match id list from match list response', () async {
    final matches = service.parseMatchList(
        '["NA1_match001","NA1_match002","NA1_match003"]');
    expect(matches, equals(['NA1_match001', 'NA1_match002', 'NA1_match003']));
  });
  test('parses match data from match response', () async {
    final result = service.parseMatchData('{"info":{"participants":[]}}');
    expect(result['info'], isNotNull);
  });
}