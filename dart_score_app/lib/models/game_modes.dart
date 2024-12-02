import 'package:dart_score_app/providers/game_provider.dart';

abstract class GameMode {
  String name;
  String description;

  GameMode(this.name, this.description);

  bool isGameOver(List<Player> players);
  void processThrow(Player player, int score);
  String getPlayerStatus(Player player);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameMode &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class BasicMode extends GameMode {
  BasicMode()
      : super('Basic', 'Highest score wins after a set number of rounds');

  @override
  bool isGameOver(List<Player> players) {
    // In basic mode, the game is over after a set number of rounds (e.g., 10)
    return players.any((player) => player.scores.length >= 10);
  }

  @override
  void processThrow(Player player, int score) {
    player.addScore(score);
  }

  @override
  String getPlayerStatus(Player player) {
    return 'Total: ${player.totalScore}';
  }
}

class Mode501 extends GameMode {
  Mode501() : super('501', 'First to reach exactly 0 from 501 points wins');

  @override
  bool isGameOver(List<Player> players) {
    return players.any((player) => player.totalScore == 0);
  }

  @override
  void processThrow(Player player, int score) {
    int newScore = player.totalScore - score;
    if (newScore >= 0) {
      player.subtractScore(score);
    }
  }

  @override
  String getPlayerStatus(Player player) {
    return 'Remaining: ${player.totalScore}';
  }
}
