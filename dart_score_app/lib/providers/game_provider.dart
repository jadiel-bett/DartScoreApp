import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:math';

class GameProvider with ChangeNotifier {
  List<Player> players = [];
  bool isGameActive = false;
  int currentPlayerIndex = 0;
  Timer? gameTimer;

  void startGame(List<String> playerNames) {
    players = playerNames.map((name) => Player(name)).toList();
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
      players[currentPlayerIndex].addScore(score);
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
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

  Player(this.name);

  void addScore(int score) {
    scores.add(score);
  }

  int get totalScore => scores.fold(0, (sum, score) => sum + score);
}
