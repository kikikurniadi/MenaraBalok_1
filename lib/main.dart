
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:meta/meta.dart';

// Variabel global untuk tema dan ukuran
const Color kBackgroundColor = Color(0xFF2C3E50);
const Color kPlayerColor = Color(0xFFE74C3C);
const Color kBlockColor = Color(0xFF3498DB);
const double kBlockHeight = 30.0;
const double kInitialBlockWidth = 200.0;

void main() {
  runApp(
    GameWidget(
      game: StackerGame(),
    ),
  );
}

// Enum untuk Status Game
enum GameState { playing, gameOver }

class StackerGame extends FlameGame with TapCallbacks {
  late TextComponent scoreText;
  late TextComponent gameOverText;

  GameState gameState = GameState.playing;
  int score = 0;
  
  double _currentBlockWidth = kInitialBlockWidth;
  
  final List<RectangleComponent> _stackedBlocks = [];
  RectangleComponent? _movingBlock;
  double _blockSpeed = 200.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topCenter;
    camera.viewfinder.position = Vector2(size.x / 2, 0);

    add(RectangleComponent(
      size: size,
      paint: Paint()..color = kBackgroundColor,
    ));

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      anchor: Anchor.topLeft,
    );
    add(scoreText);

    gameOverText = TextComponent(
      text: 'GAME OVER\nTap to Restart',
      position: size / 2,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    startGame();
  }

  void startGame() {
    gameState = GameState.playing;
    score = 0;
    _currentBlockWidth = kInitialBlockWidth;
    
    // Hapus semua balok yang ada sebelum memulai game baru
    _stackedBlocks.forEach(remove);
    _stackedBlocks.clear();
    
    if (_movingBlock != null) {
      remove(_movingBlock!);
      _movingBlock = null;
    }

    if (gameOverText.isMounted) {
      remove(gameOverText);
    }
    
    scoreText.text = 'Score: 0';
    camera.viewfinder.position = Vector2(size.x / 2, size.y * 0.1);

    final baseBlock = RectangleComponent(
      size: Vector2(kInitialBlockWidth, kBlockHeight),
      position: Vector2(size.x / 2, size.y * 0.8),
      anchor: Anchor.center,
      paint: Paint()..color = kPlayerColor,
    );
    _stackedBlocks.add(baseBlock);
    add(baseBlock);

    _spawnMovingBlock();
  }

  void _spawnMovingBlock() {
    final startX = Random().nextBool() ? 0.0 : size.x - _currentBlockWidth;
    _blockSpeed = (startX == 0.0) ? 200.0 : -200.0;

    _movingBlock = RectangleComponent(
      size: Vector2(_currentBlockWidth, kBlockHeight),
      position: Vector2(startX, _stackedBlocks.last.position.y - kBlockHeight),
      paint: Paint()..color = kBlockColor,
      key: ComponentKey.named('movingBlock'),
    );
    add(_movingBlock!);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState == GameState.playing && _movingBlock != null) {
      _movingBlock!.position.x += _blockSpeed * dt;

      if (_movingBlock!.position.x < 0) {
        _movingBlock!.position.x = 0;
        _blockSpeed *= -1;
      }
      if (_movingBlock!.position.x + _currentBlockWidth > size.x) {
          _movingBlock!.position.x = size.x - _currentBlockWidth;
          _blockSpeed *= -1;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (gameState == GameState.playing) {
      _placeBlock();
    } else {
      startGame();
    }
  }

  void _placeBlock() {
    if (_movingBlock == null) return;

    final lastBlock = _stackedBlocks.last;
    final movingBlock = _movingBlock!;

    final lastBlockLeft = lastBlock.position.x - (lastBlock.size.x * lastBlock.anchor.x);
    final lastBlockRight = lastBlockLeft + lastBlock.size.x;
    final movingBlockLeft = movingBlock.position.x;
    final movingBlockRight = movingBlockLeft + movingBlock.size.x;

    final double overlapStart = max(lastBlockLeft, movingBlockLeft);
    final double overlapEnd = min(lastBlockRight, movingBlockRight);
    final double overlapWidth = overlapEnd - overlapStart;

    if (overlapWidth > 0) {
      _currentBlockWidth = overlapWidth;

      final placedBlock = RectangleComponent(
        size: Vector2(_currentBlockWidth, kBlockHeight),
        position: Vector2(overlapStart, movingBlock.position.y),
        paint: Paint()..color = kPlayerColor,
      );
      
      remove(movingBlock);
      add(placedBlock);
      _stackedBlocks.add(placedBlock);
      
      score++;
      scoreText.text = 'Score: $score';

      camera.moveBy(Vector2(0, -kBlockHeight), speed: 150);
      _spawnMovingBlock();

    } else {
      endGame();
    }
  }

  @visibleForTesting
  void endGame() {
    gameState = GameState.gameOver;

    if (_movingBlock != null && _movingBlock!.isMounted) {
      remove(_movingBlock!);
      _movingBlock = null;
    }
    
    add(gameOverText);
  }
}
