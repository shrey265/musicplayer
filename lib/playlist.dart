import 'package:flutter/material.dart';
import 'package:music_player/songs.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  int playlistCount = 1;
  List<String> playlists = ["All Songs"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
          itemCount: playlistCount,
          itemBuilder: (context,index){
            return InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) =>  MySongs(),
                ));
              },
              child: ListTile(
                  title: Row(
                    children: [
                      const Icon(Icons.playlist_play_sharp),
                      const SizedBox(width: 20,),
                      Text(playlists[index]),
                    ],
                  ),

              ),
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        backgroundColor: Colors.deepOrange,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
