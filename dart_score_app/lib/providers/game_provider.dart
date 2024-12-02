import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:math';
import '../models/game_modes.dart';

class GameProvider with ChangeNotifier {
  List<Player> players = [];
  bool isGameActive = false;
  int currentPlayerIndex = 0;
  Timer? gameTimer;
  GameMode gameMode = BasicMode();

  void startGame(List<String> playerNames, GameMode mode) {
    gameMode = mode;
    players = playerNames
        .map((name) => Player(name, initialScore: mode is Mode501 ? 501 : 0))
        .toList();
    isGameActive = true;
    currentPlayerIndex = 0;
    notifyListeners();

    // Simulate real-time updates
    gameTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (isGameActive) {
        simulateThrow();
      }
    });
  }

  void simulateThrow() {
    if (players.isNotEmpty) {
      int score = Random().nextInt(60) + 1; // Random score between 1 and 60
      gameMode.processThrow(players[currentPlayerIndex], score);
      if (gameMode.isGameOver(players)) {
        endGame();
      } else {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      }
      notifyListeners();
    }
  }

  void endGame() {
    isGameActive = false;
    gameTimer?.cancel();
    notifyListeners();
  }

  Player? getWinner() {
    if (players.isEmpty) return null;
    return players.reduce((a, b) => a.totalScore > b.totalScore ? a : b);
  }
}

class Player {
  final String name;
  List<int> scores = [];
  int totalScore;

  Player(this.name, {int initialScore = 0}) : totalScore = initialScore;

  void addScore(int score) {
    scores.add(score);
    totalScore += score;
  }

  void subtractScore(int score) {
    scores.add(score);
    totalScore -= score;
  }
}
