// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menara_balok/src/core/services/audio_service.dart';
import 'package:menara_balok/src/core/state/game_state.dart';
import 'package:menara_balok/src/core/state/game_state_provider.dart';
import 'package:menara_balok/src/features/gameplay/components/block_component.dart';

final menaraBalokGameProvider = Provider<MenaraBalokGame>((ref) {
  return MenaraBalokGame(ref);
});

class MenaraBalokGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  final Ref ref;

  MenaraBalokGame(this.ref)
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  final Random _rand = Random();
  BlockMovement _blockMovement = BlockMovement.right;

  // The speed of the block.
  double _blockSpeed = 300;

  // The list of blocks in the game.
  final List<BlockComponent> _blocks = [];

  // Used to determine if the next block should be smaller.
  double _spawnsSincePerfect = 0;

  @override
  Future<void> onLoad() async {
    // Add the first block to the game.
    _blocks.add(
      BlockComponent(
        Vector2(size.x / 2 - 100, size.y - 50),
        Vector2(200, 50),
      ),
    );
    // Add the first block to the world.
    world.add(_blocks.first);

    _spawnBlock();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_blockMovement == BlockMovement.right) {
      _blocks.last.position.x += _blockSpeed * dt;
      if (_blocks.last.position.x + _blocks.last.size.x > size.x) {
        _blockMovement = BlockMovement.left;
      }
    } else {
      _blocks.last.position.x -= _blockSpeed * dt;
      if (_blocks.last.position.x < 0) {
        _blockMovement = BlockMovement.right;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (ref.read(gameStateProvider) == GameState.playing) {
      _handleTap();
    }
  }

  void _handleTap() {
    // Get the last two blocks.
    final BlockComponent lastBlock = _blocks.last;
    final BlockComponent secondLastBlock = _blocks[_blocks.length - 2];

    // Calculate the difference in x position between the last two blocks.
    final double diffX = lastBlock.position.x - secondLastBlock.position.x;
    final double diffAbsX = diffX.abs();

    if (diffAbsX > secondLastBlock.size.x) {
      // The player missed the block completely.
      _gameOver();
    } else {
      final bool isPerfect = _isPerfect(diffAbsX);
      if (isPerfect) {
        _handlePerfectTap(lastBlock, secondLastBlock);
      } else {
        _handleImperfectTap(lastBlock, secondLastBlock, diffX);
      }
      ref.read(audioServiceProvider).playSfx('block_placed.mp3');
      _spawnBlock();
    }
  }

  bool _isPerfect(double diffAbsX) {
    // If the difference is less than 5, it's a perfect tap.
    return diffAbsX < 5;
  }

  void _handlePerfectTap(BlockComponent lastBlock, BlockComponent secondLastBlock) {
    // The player tapped perfectly.
    // The block is the same size as the last block.
    // The block is placed directly on top of the last block.
    lastBlock.position.x = secondLastBlock.position.x;
    _spawnsSincePerfect = 0;
    ref.read(audioServiceProvider).playSfx('perfect_stack.mp3');
  }

  void _handleImperfectTap(BlockComponent lastBlock, BlockComponent secondLastBlock, double diffX) {
    // The player tapped imperfectly.
    // The block is smaller than the last block.
    // The block is placed on top of the last block, but offset.
    _spawnsSincePerfect++;
    final double newWidth = lastBlock.size.x - diffX.abs();
    lastBlock.size.x = newWidth;
    if (diffX > 0) {
      lastBlock.position.x = secondLastBlock.position.x + diffX;
    } else {
      lastBlock.position.x = secondLastBlock.position.x;
    }
  }

  void _gameOver() {
    // Remove the last block.
    world.remove(_blocks.last);
    _blocks.removeLast();
    ref.read(audioServiceProvider).playSfx('game_over.wav');

    // Save the high score.
    ref.read(scoreProvider.notifier).saveHighScore();
    // Set the game state to gameOver.
    ref.read(gameStateProvider.notifier).setGameState(GameState.gameOver);
  }

  void _spawnBlock() {
    // Increase the score.
    ref.read(scoreProvider.notifier).incrementScore();

    // Spawn a new block.
    double newWidth = _blocks.last.size.x;
    if (_spawnsSincePerfect > 0 && _spawnsSincePerfect % 3 == 0) {
      // After 3 imperfect taps, the block gets smaller.
      newWidth -= 10;
    }

    // Increase the speed of the block.
    _blockSpeed += 10;

    // Determine the starting position of the new block.
    final startingX = _rand.nextBool() ? 0.0 : size.x - newWidth;
    final newBlock = BlockComponent(
      Vector2(
        startingX,
        size.y - (_blocks.length * _blocks.last.size.y) - _blocks.last.size.y,
      ),
      Vector2(newWidth, _blocks.last.size.y),
    );
    _blocks.add(newBlock);
    world.add(newBlock);

    // If the blocks are getting too high, move the camera up.
    if (_blocks.length > 5) {
      camera.moveBy(Vector2(0, -50));
    }
  }

  void reset() {
    // Reset the camera.
    camera.moveTo(Vector2(0, 0));

    // Remove all blocks.
    for (final block in _blocks) {
      world.remove(block);
    }
    _blocks.clear();

    // Add the first block.
    _blocks.add(
      BlockComponent(
        Vector2(size.x / 2 - 100, size.y - 50),
        Vector2(200, 50),
      ),
    );
    world.add(_blocks.first);

    // Reset the score.
    ref.read(scoreProvider.notifier).resetScore();

    // Reset the block speed.
    _blockSpeed = 300;

    // Spawn the first block.
    _spawnBlock();

    // Set the game state to playing.
    ref.read(gameStateProvider.notifier).setGameState(GameState.playing);
  }
}
