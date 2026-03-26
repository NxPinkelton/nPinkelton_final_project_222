class playerRecord {
  final String puuid;
  final String championName;
  final int championLevel;
  final int championExperience;
  final int kills;
  final int deaths;
  final double kda;
  final double damagePerMinute;

  const playerRecord({
    required this.puuid,
    required this.championName,
    required this.championLevel,
    required this.championExperience,
    required this.kills,
    required this.deaths,
    required this.kda,
    required this.damagePerMinute
  });
}