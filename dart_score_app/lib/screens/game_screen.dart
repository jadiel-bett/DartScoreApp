import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game in Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: gameProvider.players.length,
                  itemBuilder: (context, index) {
                    Player player = gameProvider.players[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      color: Colors.blue.withOpacity(0.1),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(player.name,
                            style: Theme.of(context).textTheme.displayMedium),
                        subtitle: Text('Total Score: ${player.totalScore}'),
                        trailing: Text(
                          player.scores.isNotEmpty
                              ? player.scores.last.toString()
                              : '-',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    gameProvider.endGame();
                    _showGameSummary(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('End Game', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showGameSummary(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    Player? winner = gameProvider.getWinner();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Summary'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Winner: ${winner?.name ?? "No winner"}'),
              const SizedBox(height: 16),
              ...gameProvider.players.map((player) =>
                  Text('${player.name}: ${player.totalScore} points')),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
