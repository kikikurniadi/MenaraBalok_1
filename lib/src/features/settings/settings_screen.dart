// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menara_balok/src/core/services/audio_service.dart';
import 'package:menara_balok/src/core/state/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Music'),
            value: settings.isMusicEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setMusicEnabled(value);
              if (value) {
                ref.read(audioServiceProvider).playMusic();
              } else {
                ref.read(audioServiceProvider).stopMusic();
              }
            },
          ),
          SwitchListTile(
            title: const Text('SFX'),
            value: settings.areSfxsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setSfxsEnabled(value);
            },
          ),
        ],
      ),
    );
  }
}
