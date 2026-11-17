import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'asteroid.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';

///
/// The Game!
/// This is just a simple demo FlameGame to allow us to see how
/// we can use Overlays to enhance this game and see how we can
/// control the flow of the game.
///
/// Things to note:
/// - the background color of the game is changed to a ARGB color.
/// - assets are preloaded into cache.
/// - the game spawns 10 asteroids that are unmanaged.
/// - each tap adds 1 to the score and plays a sound effect.
///

class OverlayTutorial extends FlameGame with TapCallbacks, HasCollisionDetection, WidgetsBindingObserver {
  final BuildContext context;
  late final GameProvider gameProvider;  // Add this

  OverlayTutorial(this.context);

  @override
  Color backgroundColor() => const Color.fromARGB(249, 120, 86, 233);

  @override void onAttach() {
    // TODO: implement onAttach
    super.onAttach();
    WidgetsBinding.instance.addObserver(this);
  }

  @override void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print(State);
  }

  @override
  Future<void> onLoad() async {
    gameProvider = context.read<GameProvider>();

    // Preload audio so the first sound doesn't hitch.
    // The music starts from the Start Game button (overlay_title.dart).
    await FlameAudio.audioCache.loadAll(['retro_bgm.wav', 'shot.wav']);

    await images.loadAll([
      "asteroid.png",
    ]);

    for (int i = 0; i < 10; i++) {
      add(Asteroid());
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    // Empty for now - we could add tap handling here

    // Increment score
    gameProvider.incrementScore(1);

    // Play sound effect
    gameProvider.playSfx('shot.wav');
  }
}
