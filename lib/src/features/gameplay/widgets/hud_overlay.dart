// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menara_balok/src/core/state/game_state.dart';
import 'package:menara_balok/src/core/state/game_state_provider.dart';
import 'package:menara_balok/src/features/gameplay/game/menara_balok_game.dart';

class HudOverlay extends ConsumerWidget {
  final MenaraBalokGame game;
  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    final gameState = ref.watch(gameStateProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score: $score',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              if (gameState == GameState.playing) {
                ref.read(gameStateProvider.notifier).setGameState(GameState.menu);
                context.go('/');
              } else {
                game.reset();
              }
            },
            icon: Icon(
              gameState == GameState.playing ? Icons.pause : Icons.play_arrow,
            ),
          )
        ],
      ),
    );
  }
}
