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

  /// Returns a display-ready string for the given stat label.
  String formattedStatRow(String stat) {
    switch (stat) {
      case 'Champion': return championName;
      case 'Champion Level': return '$championLevel';
      case 'Kills': return '$kills';
      case 'Deaths': return '$deaths';
      case 'KDA': return kda.toStringAsFixed(2);
      case 'Damage / Min': return damagePerMinute.toStringAsFixed(1);
      default: return '';
    }
  }
}