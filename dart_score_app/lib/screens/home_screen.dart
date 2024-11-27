import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart Scoring App'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Dart Scoring',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ..._controllers.asMap().entries.map((entry) {
              int idx = entry.key;
              var controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Player ${idx + 1} Name',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white10,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                List<String> playerNames = _controllers
                    .map((controller) => controller.text.trim())
                    .where((name) => name.isNotEmpty)
                    .toList();
                if (playerNames.length >= 2) {
                  Provider.of<GameProvider>(context, listen: false)
                      .startGame(playerNames);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GameScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter at least 2 player names')),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Start Game', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
