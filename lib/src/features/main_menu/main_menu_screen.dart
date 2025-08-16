// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menara_balok/src/core/services/audio_service.dart';
import 'package:menara_balok/src/core/services/persistence_service.dart';
import 'package:menara_balok/src/core/state/game_state.dart';
import 'package:menara_balok/src/core/state/game_state_provider.dart';
import 'package:menara_balok/src/features/gameplay/game/menara_balok_game.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(audioServiceProvider).playMusic();
    final game = ref.read(menaraBalokGameProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Menara Balok',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(gameStateProvider.notifier).setGameState(GameState.playing);
                game.reset();
                context.go('/game');
              },
              child: const Text('START'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/settings');
              },
              child: const Text('SETTINGS'),
            ),
            const SizedBox(height: 20),
            Text(
              'Highscore: ${ref.watch(persistenceServiceProvider).getHighScore()}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
