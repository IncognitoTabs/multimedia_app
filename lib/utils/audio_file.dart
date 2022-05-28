import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  final String path;
  const AudioFile({Key? key, required this.advancedPlayer, required this.path}) : super(key: key);

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool isPlaying = false;
  bool isPause = false;
  bool isRepeat = false;
  final List<IconData> _icons = [
    CupertinoIcons.play_circle_fill,
    CupertinoIcons.pause_circle_fill,
  ];

  Color activeStateColor = Colors.blue;
  Color noActiveStateColor = Colors.black;

  @override
  void initState() {
    super.initState();

    widget.advancedPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration = event;
      });
    });
    widget.advancedPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        _position = event;
      });
    });
    widget.advancedPlayer.setUrl(widget.path);
    widget.advancedPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = const Duration(seconds: 0);
        if(isRepeat == false){
          isPlaying = false;
          isRepeat = false;
        }else {
          isPlaying = true;
        }
      });
    });
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
    widget.advancedPlayer.seek(newDuration);
  }

  Widget btnSlow(){
    return IconButton(
        onPressed: (){
          widget.advancedPlayer.setPlaybackRate(playbackRate: .5);
        },
        icon: ImageIcon(
          const AssetImage('assets/img/backword.png'),
          size: 15,
          color: noActiveStateColor,
        )
    );
  }

  Widget btnFast(){
    return IconButton(
        onPressed: (){
          widget.advancedPlayer.setPlaybackRate(playbackRate: 1.5);
        },
        icon: ImageIcon(
          const AssetImage('assets/img/forward.png'),
          size: 15,
          color: noActiveStateColor,
        )
    );
  }

  Widget btnRepeat(){
    return IconButton(
        onPressed: (){
          if(isRepeat == false){
            widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP);
            setState(() {
              isRepeat = true;
            });
          }
          else{
            widget.advancedPlayer.setReleaseMode(ReleaseMode.RELEASE);
            setState(() {
              isRepeat = false;
            });
          }
        },
        icon: ImageIcon(
          const AssetImage('assets/img/repeat.png'),
          size: 15,
          color: isRepeat == true? activeStateColor : noActiveStateColor,
        )
    );
  }

  Widget btnLoop(){
    return IconButton(
        onPressed: (){

        },
        icon: const ImageIcon(
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
            widget.advancedPlayer.play(widget.path);
            setState(() {
              isPlaying = true;
            });
          }
          else{
            widget.advancedPlayer.pause();
            setState(() {
              isPlaying = false;
            });
          }
        },
    );
  }

  Widget loadAsset(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btnRepeat(),
        btnSlow(),
        btnStart(),
        btnFast(),
        btnLoop(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_position.toString().split(".")[0], style: const TextStyle(fontSize: 16),),
              Text(_duration.toString().split(".")[0], style: const TextStyle(fontSize: 16),),
            ],
          ),
        ),
        slider(),
        loadAsset(),
      ],
    );
  }
}
