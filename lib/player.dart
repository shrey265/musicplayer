import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/main.dart';
import 'package:music_player/songs.dart';

class Player extends StatefulWidget {
  final Uri uri;
  final String song;
  const Player({Key? key, required this.uri, required this.song}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState(uri: uri, song: song);
}

class _PlayerState extends State<Player> with WidgetsBindingObserver{
  final Uri uri;
  final String song;
  AudioPlayer _audioPlayer = AudioPlayer();
  @override
  _PlayerState({required this.uri, required this.song});
  void initState() {
    super.initState();
    // Set a sequence of audio sources that will be played by the audio player.
    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(uri),
    ]))
        .catchError((error) {
      // catch load errors: 404, invalid url ...
      print("An error occured $error");
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MySongs(),
              ));
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          song,
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<PlayerState>(
          stream: _audioPlayer.playerStateStream,
          builder: (context,snapshot){
            final playerState = snapshot.data;
            return _playerButton(playerState!);
          },
        ),
      ),
    );
  }

  Widget _playerButton(PlayerState playerState) {

    // 1
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {

      // 2
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    } else if (_audioPlayer.playing != true) {

      // 3
      return IconButton(
        icon: const Icon(Icons.play_arrow,
          color: Colors.red,
        ),
        iconSize: 64.0,
        onPressed: _audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {

      // 4
      return IconButton(
        icon: const Icon(Icons.pause,
        color: Colors.red,
        ),
        iconSize: 64.0,
        onPressed: _audioPlayer.pause,
      );
    } else {

      // 5
      return IconButton(
        icon: const Icon(Icons.replay,
        color: Colors.red,
        ),
        iconSize: 64.0,
        onPressed: () => _audioPlayer.seek(Duration.zero,
            index: _audioPlayer.effectiveIndices?.first
        ),
      );
    }
  }

}

