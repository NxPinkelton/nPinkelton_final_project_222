import 'dart:convert';
import 'package:http/http.dart' as http;
import 'url_builder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EsportsService {
  final _urlBuilder = UrlBuilder();

  Map<String, String> get headers =>
      {'X-Riot-Token': dotenv.env['RIOT_API_KEY'] ?? ''};

  String parseIdentification(String body) =>
      jsonDecode(body)['puuid'] as String;

  List<String> parseMatchList(String body) =>
      List<String>.from(jsonDecode(body));

  Map<String, dynamic> parseMatchData(String body) =>
      jsonDecode(body) as Map<String, dynamic>;

  Future<String> requestIdentification(String username, String tag) async {
    final response = await http.get(_urlBuilder.buildUrl(username, tag), headers: headers);
    return parseIdentification(response.body);
  }

  Future<List<String>> requestMatchList(String puuid) async {
    final response = await http.get(_urlBuilder.buildMatchId(puuid), headers: headers);
    return parseMatchList(response.body);
  }

  Future<Map<String, dynamic>> requestMatchData(String matchId) async {
    final response = await http.get(_urlBuilder.buildMatchUrl(matchId), headers: headers);
    return parseMatchData(response.body);
  }
}