import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: 'iVittar',
    home: AppHome(),
    theme: ThemeData(
      primaryColor: Colors.pink,
      accentColor: Colors.pinkAccent
    ),
  ));
}

final AssetsAudioPlayer player = AssetsAudioPlayer();
void playSong(String name) {
  player.stop();
  player.open(AssetsAudio(
    asset: name,
    folder: "assets/audio/",
  ));
  player.play();
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iVittar'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              tooltip: 'All',
              onPressed: () async {
                var content = await DefaultAssetBundle.of(context).loadString(
                    'AssetManifest.json');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SongList(content)),
                );
              }
          )
        ],
      ),
      body: Center(
        child: Transform.scale(
          scale: 1.5,
          child: MaterialButton(
              child: Text('Random Vittar'),
              textColor: Colors.white,
              color: Colors.pinkAccent,
              shape: StadiumBorder(),
              onPressed: () async {
                var content = await DefaultAssetBundle.of(context)
                    .loadString('AssetManifest.json');
                Map<String, dynamic> map = jsonDecode(content);
                List<String> names = [];
                map.keys.where((key) => key.contains('assets/audio/'))
                    .forEach((str) =>
                    names.add(str.replaceAll('assets/audio/', '')));
                playSong((names..shuffle()).first);
              }
          )
        )
      ),
    );
  }
}

class SongList extends StatelessWidget {

  SongList(this.content);

  final String content;
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = jsonDecode(content);
    List<String> names = [];
    map.keys.where((key) => key.contains('assets/audio/')).forEach((str) =>
        names.add(str.replaceAll('assets/audio/', '')));

    return Scaffold(
        appBar: AppBar(
            title: Text('Songs')
        ),
        body: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: names.length,
            itemBuilder: (context, index) {
              String str = names[index];
              return ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text(str),
                  trailing: IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () async {
                        ByteData data = await rootBundle.load('assets/audio/' + str);
                        await Share.files(
                            'Share', {'audio.mp3': data.buffer.asUint8List()}, 'audio/mpeg');
                      },
                  ),
                  onTap: () => playSong(str),
              );
            }
        )
    );
  }
}

class Counter extends StatefulWidget {
  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<Counter> {

  int count = 0;

  void increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RaisedButton(
          onPressed: increment,
          child: Text('Increment'),
        ),
        Text('Count: $count')
      ],
    );
  }
}

class TutorialHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu), tooltip: 'Navigation Menu', onPressed: null),
        title: Text('Welcome Title'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), tooltip: 'Search', onPressed: null)
        ],
      ),
      body: Center(
        child: Text('Hello World')
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {

  MyAppBar({this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.blue[500]),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation Menu',
            onPressed: null
          ),
          Expanded(
            child: title
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          )
        ],
      )
    );
  }
}

class MyScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          MyAppBar(
            title: Text(
              'Example title',
              style: Theme.of(context).primaryTextTheme.title,
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }
}
