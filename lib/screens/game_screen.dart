import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../models/game_objects.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Plane> _planes = [];
  final List<Plane2> _planes2 = [];
  final List<Missile> _missiles = [];
  final List<Explosion> _explosions = [];
  int _score = 0;
  int _life = 10;
  late double _screenWidth, _screenHeight;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_gameLoop)
      ..repeat();
  }

  void _gameLoop() {
    if (_isGameOver) return;

    _updatePlanes();
    _updateMissiles();
    _updateExplosions();
    _checkCollisions();
    _checkLife();

    setState(() {});
  }

  void _updatePlanes() {
    for (var plane in _planes) {
      plane.update();
      if (plane.x < -plane.width) {
        plane.reset(_screenWidth, _screenHeight);
        _life--;
      }
    }
    for (var plane in _planes2) {
      plane.update();
      if (plane.x > _screenWidth) {
        plane.reset(_screenWidth, _screenHeight);
        _life--;
      }
    }
  }

  void _updateMissiles() {
    _missiles.removeWhere((missile) => missile.y < -missile.height);
  }

  void _updateExplosions() {
    _explosions.removeWhere((explosion) => explosion.isComplete);
  }

  void _checkCollisions() {
    _missiles.toList().forEach((missile) {
      for (var plane in _planes.toList()) {
        if (_isColliding(missile, plane)) {
          _explosions.add(Explosion(plane.x, plane.y));
          _missiles.remove(missile);
          plane.reset(_screenWidth, _screenHeight);
          _score += 10;
        }
      }
      for (var plane in _planes2.toList()) {
        if (_isColliding(missile, plane)) {
          _explosions.add(Explosion(plane.x, plane.y));
          _missiles.remove(missile);
          plane.reset(_screenWidth, _screenHeight);
          _score += 10;
        }
      }
    });
  }

  bool _isColliding(Missile missile, GameObject plane) {
    return missile.x < plane.x + plane.width &&
        missile.x + missile.width > plane.x &&
        missile.y < plane.y + plane.height &&
        missile.y + missile.height > plane.y;
  }

  void _checkLife() {
    if (_life <= 0) {
      _isGameOver = true;
      Navigator.pushReplacementNamed(context, '/gameOver', arguments: _score);
    }
  }

  void _fireMissile() {
    if (_missiles.length < 3) {
      _missiles.add(Missile(
          _screenWidth / 2 - 10,
          _screenHeight - 100 - 40
      ));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;

    // Initialize game objects
    if (_planes.isEmpty) {
      for (int i = 0; i < 2; i++) {
        _planes.add(Plane(_screenWidth, _screenHeight));
        _planes2.add(Plane2(_screenWidth, _screenHeight));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) => _fireMissile(),
        child: Stack(
          children: [
            _buildBackground(),
            ..._planes.map((plane) => plane.build()),
            ..._planes2.map((plane) => plane.build()),
            ..._missiles.map((missile) => missile.build()),
            ..._explosions.map((explosion) => explosion.build()),
            _buildTank(),
            _buildScore(),
            _buildHealthBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/background.png'),
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _buildTank() => Positioned(
    left: _screenWidth/2 - 25,
    top: _screenHeight - 125,
    child: Image.asset('assets/images/tank.png', width: 50, height: 50),
  );

  Widget _buildScore() => Positioned(
    top: 20,
    left: 20,
    child: Text('Score: $_score', style: TextStyle(fontSize: 24, color: Colors.red)),
  );

  Widget _buildHealthBar() => Positioned(
    top: 20,
    right: 20,
    child: Container(
      width: 100,
      height: 20,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: LinearProgressIndicator(
        value: _life / 10,
        backgroundColor: Colors.red,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}