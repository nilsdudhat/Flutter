import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int time = 0;
  final player = AudioPlayer();

  Future<void> playAudio() async {
    await player.setSourceAsset("audios/tik.flac");
  }

  @override
  void initState() {
    super.initState();

    playAudio().then((value) {
      Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          setState(() {
            time++;
          });

          await player.setSourceAsset("audios/tik.flac");
          await player.resume();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Audio Play Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$time"),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text("Play"),
            ),
          ],
        ),
      ),
    );
  }
}

enum PopupAction {
  add,
  remove,
}
