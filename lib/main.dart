import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const GuessGameApp());
}

class GuessGameApp extends StatelessWidget {
  const GuessGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GuessGameScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to Guess Game!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}

class GuessGameScreen extends StatefulWidget {
  const GuessGameScreen({super.key});

  @override
  _GuessGameScreenState createState() {
    return _GuessGameScreenState();
  }
}

class _GuessGameScreenState extends State<GuessGameScreen> {
  late int _targetNumber;
  late String _message;
  late Random _random;

  @override
  void initState() {
    super.initState();
    _random = Random();
    _startNewGame();
  }

  void _startNewGame() {
    _targetNumber = _random.nextInt(10) + 1; // Range from 1 to 10
    setState(() {
      _message = 'Can you guess the number behind the question mark?';
    });
  }

  void _handleUserGuess(int guess) {
    setState(() {
      if (guess == _targetNumber) {
        _message = 'Congratulations!! You guessed it successfully.\nDo you want to try again?';
      } else {
        _message = 'Too bad, Want to try again?';
      }
    });
  }

  void _showGuessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int? userGuess;
        return AlertDialog(
          title: const Text('Enter your guess'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              userGuess = int.tryParse(value);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a number between 1 and 10',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (userGuess != null) {
                  Navigator.of(context).pop();
                  _handleUserGuess(userGuess!);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _handleYesNoResponse(bool yes) {
    if (yes) {
      if (_message.contains('Congratulations!!')) {
        _startNewGame();
      } else if (_message.contains('Too bad')) {
        _showGuessDialog();
      } else {
        _showGuessDialog();
      }
    } else {
      _showThankYouAndExit();
    }
  }

  void _showThankYouAndExit() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Thank you for playing!\n App will close in 5 seconds'),
        );
      },
    );
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '?',
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleYesNoResponse(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _handleYesNoResponse(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
