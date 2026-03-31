import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'player_record.dart';
import 'riot_api_parser.dart';
import 'data_parser.dart';

/// Provides access to the Riot Games API for match and account data.
class EsportsService {
  final _urlBuilder = UrlBuilder();
  final _parser = RiotApiParser();
  final _matchParser = DataParser();

  Map<String, String> get _headers =>
      {'X-Riot-Token': dotenv.env['RIOT_API_KEY'] ?? ''};

  /// Returns the [Puuid] of the account identified by [username] and [tag].
  Future<Puuid> requestIdentification(String username, String tag) async {
    final response = await http.get(
      _urlBuilder.buildUrl(username, tag),
      headers: _headers,
    );
    return _parser.parseIdentification(response.body);
  }

  /// Returns a list of recent match IDs for the account with the given [puuid].
  Future<List<String>> requestMatchList(Puuid puuid) async {
    final response = await http.get(
      _urlBuilder.buildMatchId(puuid),
      headers: _headers,
    );
    return _parser.parseMatchList(response.body);
  }

  /// Returns the raw match data map for the match identified by [matchId].
  Future<Map<String, dynamic>> requestMatchData(String matchId) async {
    final response = await http.get(
      _urlBuilder.buildMatchUrl(matchId),
      headers: _headers,
    );
    return _parser.parseMatchData(response.body);
  }

  /// Returns the [PlayerRecord] for the given [username] and [tag].
  Future<playerRecord> requestPlayerData(String username, String tag) async {
    final puuid = await requestIdentification(username, tag);
    final matchIds = await requestMatchList(puuid);
    final matchData = await requestMatchData(matchIds.first);
    return _matchParser.playerByPuuid(jsonEncode(matchData), puuid: puuid)!;
  }
}