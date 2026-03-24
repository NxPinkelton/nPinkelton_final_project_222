import 'dart:convert';

class DataParser {
  Map<String, dynamic>? searchPlayerId(String content, String playerId) {
    final decoded = jsonDecode(content);
    final listOfParticipants = decoded['info']['participants'];
    for (Map<String, dynamic> participant in listOfParticipants) {
      if (participant['puuid'] == playerId) {
        return participant;
      }
    }
    return null;
  }

  Map<String, dynamic>? pullCharacterInfo(Map<String, dynamic> participant) {
    return {
      'championName': participant['championName'],
      'champLevel': participant['champLevel'],
      'champExperience': participant['champExperience'],
    };
  }

  Map<String, dynamic>? pullGameStatistics(Map<String, dynamic> participant) {
    return {
      'kills': participant['kills'],
      'deaths': participant['deaths'],
      'kda': participant['challenges']['kda'],
      'damagePerMinute': participant['challenges']['damagePerMinute'],
    };
  }
}