import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Game Random - with JoyStick'),
          centerTitle: true,
          backgroundColor: Colors.lightBlue.shade100,
        ),
        body: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double ballX = 0;
  double ballY = 0;
  double ballSpeed = 15.0;
  double ballSize = 30.0;
  double targetX = 0;
  double targetY = 0;
  double targetSize = 20.0;
  bool gameFinished = false;
  late double maxX;
  late double maxY;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetGame();
    });
  }

  void resetGame() {
    setState(() {
      ballX = maxX / 2;
      ballY = maxY / 2;
      gameFinished = false;
      targetX = random.nextDouble() * (maxX - targetSize * 2) + targetSize;
      targetY = random.nextDouble() * (maxY / 3) + targetSize;
    });
  }

  void checkGameStatus() {
    double dx = ballX - targetX;
    double dy = ballY - targetY;
    double distance = sqrt(dx * dx + dy * dy);
    if (distance < (ballSize + targetSize) / 2) {
      if (!gameFinished) {
        setState(() {
          gameFinished = true;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Congratulations!'),
              content: Text(
                  'You hit the target at X: ${targetX.toStringAsFixed(1)}, Y: ${targetY.toStringAsFixed(1)}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: const Text('Play Again'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void updateBallPosition(double x, double y) {
    if (gameFinished) return;
    setState(() {
      ballX += x * ballSpeed;
      ballY += y * ballSpeed;
      ballX = ballX.clamp(ballSize / 2, maxX - ballSize / 2);
      ballY = ballY.clamp(ballSize / 2, maxY - ballSize / 2);
      checkGameStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    maxX = screenSize.width;
    maxY = screenSize.height - 100;
    return Stack(
      children: [
        Positioned(
          left: targetX - targetSize / 2,
          top: targetY - targetSize / 2,
          child: Container(
            width: targetSize,
            height: targetSize,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),
        Positioned(
          left: ballX - ballSize / 2,
          top: ballY - ballSize / 2,
          child: Container(
            width: ballSize,
            height: ballSize,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black38,
            child: Text(
              'Ball: X: ${ballX.toStringAsFixed(1)}, Y: ${ballY.toStringAsFixed(1)}\n'
              'Target: X: ${targetX.toStringAsFixed(1)}, Y: ${targetY.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.withAlpha((0.7 * 255).toInt()),
            ),
            onPressed: resetGame,
            child:
                const Text('Reset Game', style: TextStyle(color: Colors.white)),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 0,
          left: 0,
          child: Container(
            alignment: Alignment.center,
            child: Joystick(
              listener: (details) {
                updateBallPosition(details.x, details.y);
              },
            ),
          ),
        ),
      ],
    );
  }
}