import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_app/pages/profile_page.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;

class DetailOnlineAudioPage extends StatefulWidget {
  final detailAudio;
  int index;

  DetailOnlineAudioPage({Key? key, required this.detailAudio, required this.index}) : super(key: key) ;

  @override
  State<DetailOnlineAudioPage> createState() => _DetailOnlineAudioPageState();
}

class _DetailOnlineAudioPageState extends State<DetailOnlineAudioPage> {

  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool isPlaying = false;
  bool isAutoNext = false;
  bool isRepeat = false;
  final List<IconData> _icons = [
    CupertinoIcons.play_circle_fill,
    CupertinoIcons.pause_circle_fill,
  ];

  Color activeStateColor = Colors.blue;
  Color noActiveStateColor = Colors.black;
  
  late AudioPlayer advancedPlayer;

  @override
  void dispose(){
    super.dispose();
    advancedPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();

    advancedPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration = event;
      });
    });
    advancedPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        _position = event;
      });
    });
    advancedPlayer.play(widget.detailAudio[widget.index]["audio"]);
    isPlaying = true;
    advancedPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        _position = const Duration(seconds: 0);
        if(isRepeat == false && isAutoNext == false){
          isPlaying = false;
        }else if(isRepeat == false && isAutoNext == true){
          widget.index = getAudioIndex(widget.index + 1);
          advancedPlayer.play(widget.detailAudio[widget.index]["audio"]);
          isPlaying = true;
          isRepeat = false;
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
    advancedPlayer.seek(newDuration);
  }

  int getAudioIndex(int i) {
    int result = 0;
    if(i >= widget.detailAudio.length){
      result = 0;
    }else if (i<0){
      result = widget.detailAudio.length - 1;
    }else{
      result = i;
    }
    return result;
  }

  Widget btnPrevious(){
    return IconButton(
        onPressed: (){
          widget.index = getAudioIndex(widget.index - 1);
          advancedPlayer.play(widget.detailAudio[widget.index]["audio"]);
          setState(() {
            isPlaying = true;
          });
        },
        icon: ImageIcon(
          const AssetImage('assets/img/backword.png'),
          size: 15,
          color: noActiveStateColor,
        )
    );
  }

  Widget btnNext(){
    return IconButton(
        onPressed: (){
          widget.index = getAudioIndex(widget.index + 1);
          advancedPlayer.play(widget.detailAudio[widget.index]["audio"]);
          setState(() {
            isPlaying = true;
          });
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
            advancedPlayer.setReleaseMode(ReleaseMode.LOOP);
            setState(() {
              isRepeat = true;
              isAutoNext = false;
            });
          }
          else{
            advancedPlayer.setReleaseMode(ReleaseMode.RELEASE);
            setState(() {
              isRepeat = false;
            });
          }
        },
        icon: ImageIcon(
          const AssetImage('assets/img/repeat_one.png'),
          size: 22,
          color: isRepeat == true? activeStateColor : noActiveStateColor,
        )
    );
  }

  Widget btnAutoNext(){
    return IconButton(
        onPressed: (){
          if(isAutoNext == false){
            advancedPlayer.setReleaseMode(ReleaseMode.RELEASE);
            setState(() {
              isAutoNext = true;
              isRepeat = false;
            });
          }
          else{
            setState(() {
              isAutoNext = false;
            });
          }
        },
        icon: ImageIcon(
          const AssetImage('assets/img/loop.png'),
          size: 15,
          color: isAutoNext == true? activeStateColor : noActiveStateColor,
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
          advancedPlayer.play(widget.detailAudio[widget.index]["audio"]);
          setState(() {
            isPlaying = true;
          });
        }
        else{
          advancedPlayer.pause();
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
        btnPrevious(),
        btnStart(),
        btnNext(),
        btnAutoNext(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.audioBluishBackground,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight/3,
              child: Container(
                color: AppColors.audioBlueBackground,
              )
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
                actions: [
                  InkWell(
                    child:  const CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(AppParams.avatarUrl),
                    ),
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfilePage()
                        )
                      );
                    }
                  ),
                  const SizedBox(width: 10,)
                ],
                backgroundColor: AppColors.audioBlueBackground,
                shadowColor: Colors.transparent,
              )
          ),
          Positioned(
              left: 0,
              right: 0,
              top: screenHeight * .2,
              height: screenHeight * .36,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * .08,),
                    Text(widget.detailAudio[widget.index]["title"]
                      ,style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(widget.detailAudio[widget.index]["text"]
                      ,style: TextStyle(
                        fontSize: 18,
                        color: AppColors.subTitleText
                      ),
                    ),
                    Column(
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
                    )
                  ],
                ),
              )
          ),
          Positioned(
              top: screenHeight * .12,
              left: (screenWidth - AppParams.imageContainerSize)/2,
              right: (screenWidth - AppParams.imageContainerSize)/2,
              height: AppParams.imageContainerSize,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 5),
                  color: AppColors.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(widget.detailAudio[widget.index]["img"]),
                          fit: BoxFit.fill
                        ),
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
