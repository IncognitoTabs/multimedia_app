import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  const AudioFile({Key? key, required this.advancedPlayer}) : super(key: key);

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  final String path = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3";
  bool isPlaying = false;
  bool isPause = false;
  bool isRepeat = false;
  List<IconData> _icons = [
    Icons.play_circle,
    Icons.pause_circle,
  ];

  Color activeStateColor = Colors.blue;
  Color noActiveStateColor = Colors.black;

  @override
  void initState() {
    super.initState();
    this.widget.advancedPlayer.onDurationChanged.listen((event) {setState(() {
      _duration = event;
    });});
    this.widget.advancedPlayer.onAudioPositionChanged.listen((event) {setState(() {
      _position = event;
    });});
    this.widget.advancedPlayer.setUrl(path);
  }

  Widget slider(){
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value){
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        }
    );
  }

  void changeToSecond(int sec){
    Duration newDuration = Duration(seconds: sec);
    this.widget.advancedPlayer.seek(newDuration);
  }

  Widget btnSlow(){
    return IconButton(
        onPressed: (){
          this.widget.advancedPlayer.setPlaybackRate(playbackRate: .5);
        },
        icon: ImageIcon(
          AssetImage('assets/img/backword.png'),
          size: 15,
          color: noActiveStateColor,
        )
    );
  }

  Widget btnFast(){
    return IconButton(
        onPressed: (){
          this.widget.advancedPlayer.setPlaybackRate(playbackRate: 1.5);
        },
        icon: ImageIcon(
          AssetImage('assets/img/forward.png'),
          size: 15,
          color: noActiveStateColor,
        )
    );
  }

  Widget btnRepeat(){
    return IconButton(
        onPressed: (){
          if(isRepeat == false){
            this.widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP);
            setState(() {
              isRepeat = true;
            });
          }
          else{
            this.widget.advancedPlayer.setReleaseMode(ReleaseMode.RELEASE);
            setState(() {
              isRepeat = false;
            });
          }
        },
        icon: ImageIcon(
          AssetImage('assets/img/repeat.png'),
          size: 15,
          color: isRepeat == true? activeStateColor : noActiveStateColor,
        )
    );
  }

  Widget btnLoop(){
    return IconButton(
        onPressed: (){

        },
        icon: ImageIcon(
          AssetImage('assets/img/loop.png'),
          size: 15,
        )
    );
  }

  Widget btnStart(){
    return IconButton(
      padding: const EdgeInsets.only(bottom: 10),
      icon: isPlaying == false
          ? Icon(_icons[0], size: 40, color: activeStateColor,)
          : Icon(_icons[1], size: 40,color: activeStateColor,),
      onPressed: (){
          if(isPlaying == false){
            this.widget.advancedPlayer.play(path);
            setState(() {
              isPlaying = true;
            });
          }
          else{
            this.widget.advancedPlayer.pause();
            setState(() {
              isPlaying = false;
            });
          }
        },
    );
  }

  Widget loadAsset(){
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          btnRepeat(),
          btnSlow(),
          btnStart(),
          btnFast(),
          btnLoop(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_position.toString().split(".")[0], style: TextStyle(fontSize: 16),),
                Text(_duration.toString().split(".")[0], style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
          slider(),
          loadAsset(),
        ],
      ),
    );
  }
}
