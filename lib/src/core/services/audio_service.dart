// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menara_balok/src/core/state/settings_provider.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService(ref);
});

class AudioService {
  final Ref ref;

  AudioService(this.ref);

  Future<void> preloadAssets() async {
    await FlameAudio.audioCache.loadAll([
      'block_placed.mp3',
      'perfect_stack.mp3',
      'game_over.wav',
      'music.mp3',
    ]);
  }

  void playMusic() {
    if (ref.read(settingsProvider).isMusicEnabled) {
      FlameAudio.bgm.play('music.mp3');
    }
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  void playSfx(String sfx) {
    if (ref.read(settingsProvider).areSfxsEnabled) {
      FlameAudio.play(sfx);
    }
  }
}
