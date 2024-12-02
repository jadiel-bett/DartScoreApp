import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';
import '../models/game_modes.dart';
import 'login_screen.dart';

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
  GameMode _selectedGameMode = BasicMode();
  final List<GameMode> _gameModes = [BasicMode(), Mode501()];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart Score'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to Dart Score',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ..._controllers.asMap().entries.map((entry) {
              int idx = entry.key;
              var controller = entry.value;
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width / 6, vertical: 8),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 6),
              child: _buildGameModeSelector(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width / 8,
                vertical: 16,
              ),
              child: ElevatedButton(
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
                        .startGame(playerNames, _selectedGameMode);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GameScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Please enter at least 2 player names')),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Start Game',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeSelector() {
    return Row(
      children: [
        const Text('Game Mode: '),
        DropdownButton<GameMode>(
          value: _selectedGameMode,
          items: _gameModes.map((GameMode mode) {
            return DropdownMenuItem<GameMode>(
              value: mode,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  mode.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          onChanged: (GameMode? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedGameMode = newValue;
              });
            }
          },
          dropdownColor: Theme.of(context).primaryColor,
          style: const TextStyle(color: Colors.white),
          underline: Container(
            height: 0,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ],
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
