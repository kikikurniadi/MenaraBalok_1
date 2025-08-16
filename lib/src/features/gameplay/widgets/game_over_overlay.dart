// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menara_balok/src/core/state/game_state.dart';
import 'package:menara_balok/src/core/state/game_state_provider.dart';
import 'package:menara_balok/src/features/gameplay/game/menara_balok_game.dart';

class GameOverOverlay extends ConsumerWidget {
  final MenaraBalokGame game;
  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return gameState == GameState.gameOver
        ? Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Game Over',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: ${ref.read(scoreProvider)}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      game.reset();
                    },
                    child: const Text('Play Again'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                      ref.read(gameStateProvider.notifier).setGameState(GameState.menu);
                    },
                    child: const Text('Main Menu'),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
