import 'package:test/test.dart';
import 'package:trythisshit/url_builder.dart';

void main() {
  test('Builds URL for the PUUID', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildUrl('WombatBaby', 'NA2');
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains('WombatBaby'));
    expect(uri.path, contains('NA2'));
  });

  test('Builds the list of match ids', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildMatchId('ThisisatestidIamjuststringingwordstogether'
        'withnorealpurpose');
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains(
        'ThisisatestidIamjuststringingwordstogetherwithnorealpurpose'));
  });

  test('Builds Url for the match data', () {
    final constructor = UrlBuilder();
    final uri = constructor.buildMatchUrl('NA1_gamethathasbeenplayed');
    expect(uri.scheme, 'https');
    expect(uri.host, 'americas.api.riotgames.com');
    expect(uri.path, contains('NA1_gamethathasbeenplayed'));
  });
}