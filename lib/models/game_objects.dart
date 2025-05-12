import 'package:flutter/material.dart';
import 'dart:math';

abstract class GameObject {
  double x, y;
  final double width, height;
  final List<Image> frames;
  int currentFrame = 0;
  int frameDelay = 0;
  final Random random = Random();

  GameObject(this.x, this.y, this.width, this.height, this.frames);

  void update() {
    frameDelay++;
    if (frameDelay >= 5) {
      currentFrame = (currentFrame + 1) % frames.length;
      frameDelay = 0;
    }
  }

  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: Image(image: frames[currentFrame].image, width: width, height: height),
    );
  }
}

class Plane extends GameObject {
  late double velocity;

  Plane(double screenWidth, double screenHeight)
      : super(0, 0, 80, 80, _loadPlaneImages()) {
    reset(screenWidth, screenHeight);
  }

  static List<Image> _loadPlaneImages() => List.generate(15,
          (i) => Image.asset('assets/images/plane_${i+1}.png'));

  void reset(double sw, double sh) {
    x = sw + random.nextInt(1200).toDouble();
    y = random.nextInt(300).toDouble();
    velocity = 8 + random.nextInt(13).toDouble();
    currentFrame = 0;
  }

  @override
  void update() {
    super.update();
    x -= velocity;
  }
}

class Plane2 extends GameObject {
  late double velocity;

  Plane2(double screenWidth, double screenHeight)
      : super(0, 0, 80, 80, _loadPlane2Images()) {
    reset(screenWidth, screenHeight);
  }

  static List<Image> _loadPlane2Images() => List.generate(10,
          (i) => Image.asset('assets/images/plane2_${i+1}.png'));

  void reset(double sw, double sh) {
    x = -200 - random.nextInt(1500).toDouble();
    y = random.nextInt(400).toDouble();
    velocity = 5 + random.nextInt(21).toDouble();
    currentFrame = 0;
  }

  @override
  void update() {
    super.update();
    x += velocity;
  }
}

class Missile {
  final double x, y;
  final double width = 20;
  final double height = 40;
  final Image image;
  final double velocity = 15;

  Missile(this.x, this.y) :
        image = Image.asset('assets/images/missile.png', width: 20, height: 40);

  Missile update() => Missile(x, y - velocity);

  Widget build() => Positioned(left: x, top: y, child: image);
}

class Explosion {
  final double x, y;
  final List<Image> frames;
  int currentFrame = 0;
  bool isComplete = false;

  Explosion(this.x, this.y) : frames = _loadExplosionImages();

  static List<Image> _loadExplosionImages() => List.generate(9,
          (i) => Image.asset('assets/images/explosion_${i+1}.png'));

  void update() => currentFrame < frames.length - 1 ? currentFrame++ : isComplete = true;

  Widget build() => Positioned(
    left: x - 40,
    top: y - 40,
    child: Image(image: frames[currentFrame].image, width: 80, height: 80),
  );
}