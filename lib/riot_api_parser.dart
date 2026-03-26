import 'dart:convert';

class RiotApiParser {
  String parseIdentification(String body) =>
      jsonDecode(body)['puuid'] as String;
  List<String> parseMatchList(String body) =>
      List<String>.from(jsonDecode(body));
  Map<String, dynamic> parseMatchData(String body) =>
      jsonDecode(body) as Map<String, dynamic>;
}
