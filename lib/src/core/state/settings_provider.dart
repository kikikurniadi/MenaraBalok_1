// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menara_balok/src/core/services/persistence_service.dart';

// A provider that holds the current settings.
final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier(ref);
});

// The notifier for the settings.
class SettingsNotifier extends StateNotifier<Settings> {
  final Ref ref;

  SettingsNotifier(this.ref)
      : super(
          Settings(
            isMusicEnabled: ref.read(persistenceServiceProvider).isMusicEnabled(),
            areSfxsEnabled: ref.read(persistenceServiceProvider).areSfxsEnabled(),
          ),
        );

  void setMusicEnabled(bool isEnabled) {
    ref.read(persistenceServiceProvider).setMusicEnabled(isEnabled);
    state = state.copyWith(isMusicEnabled: isEnabled);
  }

  void setSfxsEnabled(bool areEnabled) {
    ref.read(persistenceServiceProvider).setSfxsEnabled(areEnabled);
    state = state.copyWith(areSfxsEnabled: areEnabled);
  }
}

// A class that holds the current settings.
class Settings {
  final bool isMusicEnabled;
  final bool areSfxsEnabled;

  Settings({
    required this.isMusicEnabled,
    required this.areSfxsEnabled,
  });

  Settings copyWith({
    bool? isMusicEnabled,
    bool? areSfxsEnabled,
  }) {
    return Settings(
      isMusicEnabled: isMusicEnabled ?? this.isMusicEnabled,
      areSfxsEnabled: areSfxsEnabled ?? this.areSfxsEnabled,
    );
  }
}
