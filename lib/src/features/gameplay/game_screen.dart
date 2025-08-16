// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menara_balok/src/features/gameplay/game/menara_balok_game.dart';
import 'package:menara_balok/src/features/gameplay/widgets/game_over_overlay.dart';
import 'package:menara_balok/src/features/gameplay/widgets/hud_overlay.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the single instance of the game.
    final game = ref.watch(menaraBalokGameProvider);

    return Scaffold(
      // Use the 'game' property instead of 'gameFactory' to provide the instance.
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'GameOver': (context, MenaraBalokGame game) => GameOverOverlay(game: game),
          'HUD': (context, MenaraBalokGame game) => HudOverlay(game: game),
        },
        initialActiveOverlays: const ['HUD'],
      ),
    );
  }
}
