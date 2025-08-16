// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provides a SharedPreferences instance. This is overridden in main.dart
// with the actual instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Provides a PersistenceService instance.
final persistenceServiceProvider = Provider<PersistenceService>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return PersistenceService(sharedPreferences);
});

// A service that handles saving and loading of user settings.
class PersistenceService {
  final SharedPreferences sharedPreferences;

  PersistenceService(this.sharedPreferences);

  // High score persistence
  static const _highScoreKey = 'highScore';

  int getHighScore() {
    return sharedPreferences.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveHighScore(int score) async {
    await sharedPreferences.setInt(_highScoreKey, score);
  }

  // Sound settings persistence
  static const _musicEnabledKey = 'isMusicEnabled';

  bool isMusicEnabled() {
    return sharedPreferences.getBool(_musicEnabledKey) ?? true;
  }

  Future<void> setMusicEnabled(bool isEnabled) async {
    await sharedPreferences.setBool(_musicEnabledKey, isEnabled);
  }

  static const _sfxsEnabledKey = 'areSfxsEnabled';

  bool areSfxsEnabled() {
    return sharedPreferences.getBool(_sfxsEnabledKey) ?? true;
  }

  Future<void> setSfxsEnabled(bool areEnabled) async {
    await sharedPreferences.setBool(_sfxsEnabledKey, areEnabled);
  }
}
