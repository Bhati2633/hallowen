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
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  bool _gameWon = false;
  Random _random = Random();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _playBackgroundMusic();
    _moveObjects();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.setAsset('assets/sounds/background_music.mp3');
      await _backgroundMusicPlayer.setLoopMode(LoopMode.one);
      await _backgroundMusicPlayer.play();
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundMusicPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  void _playSound(String sound) async {
    try {
      await _effectPlayer.setAsset(sound);
      _effectPlayer.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void _handleCorrectSelection() {
    setState(() {
      _gameWon = true;
    });
    _playSound('assets/sounds/success.mp3');
  }

  void _handleTrapSelection() {
    _playSound('assets/sounds/jumpscare.mp3');
  }

  double _randomPosition(double max) {
    return _random.nextDouble() * max;
  }

  void _moveObjects() {
    Future.delayed(Duration(seconds: 2), () {
      if (!_gameWon) {
        setState(() {});
        _moveObjects();
      }
    });
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
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
                  child: Image.asset('assets/images/ghost1.png', width: 100),
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
      ),
    );
  }
}