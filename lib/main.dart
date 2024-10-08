import 'package:flutter/material.dart';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(HalloweenSpookyApp());
}

class HalloweenSpookyApp extends StatefulWidget {
  @override
  _HalloweenSpookyAppState createState() => _HalloweenSpookyAppState();
}

class _HalloweenSpookyAppState extends State<HalloweenSpookyApp>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _gameWon = false;
  Random _random = Random();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller);
    
    // Play spooky background music in a loop
    _audioPlayer.setAsset('assets/sounds/spooky_background.mp3');
    _audioPlayer.setLoopMode(LoopMode.one);
    _audioPlayer.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(String sound) async {
    await _audioPlayer.setAsset(sound);
    _audioPlayer.play();
  }

  // Handle correct item selection
  void _handleCorrectSelection() {
    setState(() {
      _gameWon = true;
    });
    _playSound('assets/sounds/success.mp3');
  }

  // Handle trap selection
  void _handleTrapSelection() {
    _playSound('assets/sounds/jumpscare.mp3');
  }

  // Generate random positions for the objects
  double _randomPosition(double max) {
    return _random.nextDouble() * max;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Spooky Halloween Game"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (_gameWon)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You Found It!',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Icon(Icons.star, size: 100, color: Colors.orange),
                  ],
                ),
              ),
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              top: _randomPosition(MediaQuery.of(context).size.height - 100),
              left: _randomPosition(MediaQuery.of(context).size.width - 100),
              child: GestureDetector(
                onTap: _handleTrapSelection,
                child: Image.asset('assets/images/ghost.jpg', width: 100),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              top: _randomPosition(MediaQuery.of(context).size.height - 100),
              left: _randomPosition(MediaQuery.of(context).size.width - 100),
              child: GestureDetector(
                onTap: _handleCorrectSelection,
                child: Image.asset('assets/images/pumpkin.png', width: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
