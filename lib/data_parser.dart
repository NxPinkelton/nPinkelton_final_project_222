import 'dart:convert';
import 'player_record.dart';

typedef Puuid = String;

class DataParser {
  playerRecord? playerByPuuid(String content, {required Puuid puuid}) {
    final decoded = jsonDecode(content);
    final participants = decoded['info']['participants'] as List<dynamic>;
    for (final participant in participants) {
      if (participant['puuid'] == puuid) {
        return _toPlayerRecord(participant as Map<String, dynamic>);
      }
    }
    return null;
  }

  playerRecord _toPlayerRecord(Map<String, dynamic> player) {
    return playerRecord(
      puuid: player['puuid'] as String,
      championName: player['championName'] as String,
      championLevel: player['champLevel'] as int,
      championExperience: player['champExperience'] as int,
      kills: player['kills'] as int,
      deaths: player['deaths'] as int,
      kda: (player['challenges']['kda'] as num).toDouble(),
      damagePerMinute: (player['challenges']['damagePerMinute'] as num).toDouble(),
    );
  }
}