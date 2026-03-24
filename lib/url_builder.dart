class UrlBuilder {
  Uri buildUrl(String username, String tag) {
    return Uri.parse('https://americas.api.riotgames.com'
        '/riot/account/v1/accounts/by-riot-id/${Uri.encodeComponent(username)}/${Uri.encodeComponent(tag)}'
    );
  }
  Uri buildMatchId(String puuid) {
    return Uri.parse(
        'https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/${Uri.encodeComponent(puuid)}/ids'
    );
  }
  Uri buildMatchUrl(String matchId) {
    return Uri.parse(
        'https://americas.api.riotgames.com/lol/match/v5/matches/${Uri.encodeComponent(matchId)}'
    );
  }
}