// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menara_balok/src/core/services/persistence_service.dart';
import 'package:menara_balok/src/core/state/game_state.dart';

// A provider that holds the current game state.
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});

// The notifier for the game state.
class GameStateNotifier extends StateNotifier<GameState> {
  final Ref ref;

  GameStateNotifier(this.ref) : super(GameState.menu);

  void setGameState(GameState newState) {
    state = newState;
  }
}

// A provider that holds the current score.
final scoreProvider = StateNotifierProvider<ScoreNotifier, int>((ref) {
  return ScoreNotifier(ref);
});

// The notifier for the score.
class ScoreNotifier extends StateNotifier<int> {
  final Ref ref;

  ScoreNotifier(this.ref) : super(0);

  void setScore(int newScore) {
    state = newScore;
  }

  void incrementScore() {
    state++;
  }

  void resetScore() {
    state = 0;
  }

  // A method to save the high score if the current score is greater than the
  // current high score.
  void saveHighScore() {
    final currentHighScore = ref.read(persistenceServiceProvider).getHighScore();
    if (state > currentHighScore) {
      ref.read(persistenceServiceProvider).saveHighScore(state);
    }
  }
}
