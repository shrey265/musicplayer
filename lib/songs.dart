import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'player.dart';
import 'playlist.dart';

class MySongs extends StatefulWidget {
  const MySongs({Key? key}) : super(key: key);

  @override
  State<MySongs> createState() => _MySongsState();
}

class _MySongsState extends State<MySongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();
    requestPermission();
  }
  bool permission = false;
  requestPermission() async {
    // Web platform don't support permissions methods.
      bool permissionStatus = await _audioQuery.permissionsStatus();

      if (!permissionStatus) {
        permission = await _audioQuery.permissionsRequest();
      }
      if(permission){
        setState(() {});
      }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>  Playlist(),
            ));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('All Songs'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),

      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) return const CircularProgressIndicator();
          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>  Player(uri: Uri.parse("${item.data![index].uri}"), song: item.data![index].title),
                  ));
                },
                child: ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  //trailing: const Icon(Icons.arrow_forward_rounded),
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,

                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
