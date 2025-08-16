// integration_test/app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:menara_balok/main.dart';
import 'package:menara_balok/src/features/gameplay/game_screen.dart';
import 'package:menara_balok/src/features/main_menu/main_menu_screen.dart';
import 'package:menara_balok/src/features/settings/settings_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full App Integration Test', (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // 1. Verify that the main menu is displayed correctly
    expect(find.byType(MainMenuScreen), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'START'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'SETTINGS'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'HIGHSCORES'), findsOneWidget);

    // 2. Test navigation to the Settings screen and back
    await tester.tap(find.widgetWithText(ElevatedButton, 'SETTINGS'));
    await tester.pumpAndSettle();

    // Verify that the settings screen is displayed
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Tap the back button to return to the main menu
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that we are back on the main menu
    expect(find.byType(MainMenuScreen), findsOneWidget);

    // 3. Test starting the game
    await tester.tap(find.widgetWithText(ElevatedButton, 'START'));
    await tester.pumpAndSettle();

    // Verify that the game screen is displayed
    expect(find.byType(GameScreen), findsOneWidget);
  });
}
