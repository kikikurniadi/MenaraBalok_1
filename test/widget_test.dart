
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stacker_game/main.dart';

void main() {
  group('StackerGame', () {
    testWithGame<StackerGame>(
      'loads and has correct initial state',
      () => StackerGame(),
      (game) async {
        await game.ready();

        expect(game.score, 0);
        expect(game.gameState, GameState.playing);
        expect(game.scoreText.isMounted, isTrue);
        expect(game.gameOverText.isMounted, isFalse);
      },
    );

    testWithGame<StackerGame>(
      'tapping screen places a block',
      () => StackerGame(),
      (game) async {
        await game.ready();
        
        final initialBlockCount = game.children.whereType<RectangleComponent>().length;
        
        // Atur posisi balok bergerak secara manual untuk memastikan tumpang tindih
        final movingBlock = game.findByKeyName<RectangleComponent>('movingBlock');
        expect(movingBlock, isNotNull);
        movingBlock!.position.x = game.size.x / 2 - kInitialBlockWidth / 2;

        final tapPosition = game.size / 2;
        game.onTapDown(TapDownEvent(
          0,
          game,
          TapDownDetails(
            localPosition: Offset(tapPosition.x, tapPosition.y),
            globalPosition: Offset(tapPosition.x, tapPosition.y),
          ),
        ));
        
        game.update(0); 
        
        // Setelah penempatan berhasil, jumlah balok bertambah satu
        expect(game.children.whereType<RectangleComponent>().length, initialBlockCount + 1);
        expect(game.score, 1);
      },
    );

    testWithGame<StackerGame>(
      'game ends when a block is missed',
      () => StackerGame(),
      (game) async {
        await game.ready();

        final movingBlock = game.findByKeyName<RectangleComponent>('movingBlock');
        expect(movingBlock, isNotNull);
        // Posisikan balok jauh untuk memastikan meleset
        movingBlock!.position.x = game.size.x + 500;
        
        final tapPosition = game.size / 2;
        game.onTapDown(TapDownEvent(
          0,
          game,
          TapDownDetails(
            localPosition: Offset(tapPosition.x, tapPosition.y),
            globalPosition: Offset(tapPosition.x, tapPosition.y),
          ),
        ));

        game.update(0);

        expect(game.gameState, GameState.gameOver);
        expect(game.gameOverText.isMounted, isTrue);
      },
    );
  });
}
