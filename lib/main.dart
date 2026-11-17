import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'overlay_title.dart';
import 'overlay_main.dart';
import 'overlay_pause.dart';
import 'overlay_info.dart';
import 'overlay_settings.dart';
import 'highscores_page.dart';

import 'package:provider/provider.dart';
import 'game_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  runApp(ChangeNotifierProvider(
    create:(context) => GameProvider(),
    child: const MainApp())
  );
}

class MainApp extends StatefulWidget{
  const MainApp({super.key});
}

class _MainAppState extends State<MainApp> {

  int _currentNavScreen = 0;

  final List<Widget> _bottomNavScreens = [
    const MainGame(),
    const HighscoresPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:Text("Cool Space Game"),
        ),
        //body: _bottomNavScreens[_currentNavScreen],
        body: IndexedStack(
          index: _currentNavScreen,
          children: _bottomNavScreens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Game" 
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.score),
              label: "High Scores" 
            ),
          ] ,
          onTap: (value) {
            final gameProvider = context.read<GameProvider>();

            setState(() {
              _currentNavScreen = value;
              gameProvider.game?.paused = true;
              gameProvider.game?.overlays.add('pause');
            });
          },
        ),
      ),
    );
  }
}

class MainGame extends StatelessWidget {
  const MainGame({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final gameProvider = context.read<GameProvider>();
    final game = OverlayTutorial(context)..paused = true;
    gameProvider.game = game;

    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'title': (context, game) => OverlayTitle(game: game),
        'main': (context, game) => mainOverlay(context, game),
        'pause': (context, game) => pauseOverlay(context, game),
        'info': (context, game) => InfoOverlay(game: game as OverlayTutorial),
        'settings':(context, game) => settingsOverlay(context,game),
      },
      initialActiveOverlays: const ['title'],
    );
  }
}
