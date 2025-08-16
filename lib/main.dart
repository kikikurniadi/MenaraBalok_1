// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:menara_balok/src/core/navigation/app_router.dart';
import 'package:menara_balok/src/core/services/audio_service.dart';
import 'package:menara_balok/src/core/services/persistence_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Ensure that Flutter bindings are initialized before any Flutter code is executed.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

/// A helper class to manage the asynchronous initialization of the app.
class AppInitialization {
  static Future<ProviderContainer> initialize() async {
    // 1. Initialize SharedPreferences for persistence.
    final prefs = await SharedPreferences.getInstance();

    // 2. Initialize the audio engine.
    await FlameAudio.bgm.initialize();

    // 3. Create a Riverpod container and override the sharedPreferencesProvider
    // with the instance we just initialized.
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );

    // 4. Preload all audio assets into the cache for immediate playback.
    await container.read(audioServiceProvider).preloadAssets();

    // 5. Return the fully initialized container.
    return container;
  }
}

/// The root widget of the application that handles the bootstrap process.
/// It displays a loading screen while async services are initializing.
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final Future<ProviderContainer> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = AppInitialization.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProviderContainer>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        // If the future is complete and has data, build the main app.
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // Provide the initialized container to the rest of the app.
            return UncontrolledProviderScope(
              container: snapshot.data!,
              child: const MyApp(),
            );
          } else if (snapshot.hasError) {
            // If initialization fails, show an error screen.
            return _buildErrorScreen(snapshot.error);
          }
        }
        
        // While initializing, show a loading screen.
        return _buildLoadingScreen();
      },
    );
  }

  /// Builds a simple loading screen with a centered progress indicator.
  Widget _buildLoadingScreen() {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  /// Builds an error screen to display initialization failures.
  Widget _buildErrorScreen(Object? error) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to initialize the app.\nError: $error',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// The main application widget, which is built only after all
/// services have been successfully initialized.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Menara Balok',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // Fallback to a default TextTheme if GoogleFonts fails
        textTheme: (GoogleFonts.pressStart2pTextTheme() ?? const TextTheme()).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
    );
  }
}
