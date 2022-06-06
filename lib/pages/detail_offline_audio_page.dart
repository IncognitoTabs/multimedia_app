import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:multimedia_app/pages/profile_page.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;
import 'package:on_audio_query/on_audio_query.dart';

class DetailOfflineAudioPage extends StatefulWidget {
  int index;
  List<SongModel> list;

  DetailOfflineAudioPage({Key? key, required this.list, required this.index}) : super(key: key) ;

  @override
  State<DetailOfflineAudioPage> createState() => _DetailOfflineAudioPageState();
}

class _DetailOfflineAudioPageState extends State<DetailOfflineAudioPage> {

  bool isPlaying = false;
  bool isAutoNext = false;
  bool isRepeat = false;

  final List<IconData> _icons = [
    CupertinoIcons.play_circle_fill,
    CupertinoIcons.pause_circle_fill,
  ];

  Color activeStateColor = Colors.blue;
  Color noActiveStateColor = Colors.black;

  double currentValue = 0.0, maximumValue =0.0, minimumValue = 0.0;

  late AudioPlayer advancedPlayer ;

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }
  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
    setSong(widget.index);
    advancedPlayer.play();
    isPlaying = true;
    advancedPlayer.positionStream.listen((event) {
      currentValue = event.inSeconds.toDouble();
      setState(() {
      });
    });
    advancedPlayer.playerStateStream.listen((event) {
      if(advancedPlayer.processingState == ProcessingState.completed){
        setState(() {
          if(isRepeat == false){
            if(isAutoNext == false ){
              isPlaying = false;
            }else{
              setSong(getAudioIndex(widget.index + 1));
              advancedPlayer.play();
              isPlaying = true;
              isRepeat = false;
            }
          }
          else{
            setSong(widget.index);
            advancedPlayer.play();
          }
        });
      }
    });
  }


  void setSong(int index) async{
    widget.index = index;
    await advancedPlayer.setAudioSource(AudioSource.uri(Uri.parse(widget.list[widget.index].uri.toString())));

    currentValue = minimumValue;
    maximumValue = advancedPlayer.duration!.inSeconds.toDouble();
    setState(() {

    });
  }

  Widget slider(){
    return Slider(
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        value: currentValue,
        min: minimumValue,
        max: maximumValue,
        onChanged: (double value){
          setState(() {
            advancedPlayer.seek(Duration(seconds: currentValue.round()));
            currentValue = value;
          });
        }
    );
  }

  int getAudioIndex(int i) {
    int result = 0;
    if(i >= widget.list.length){
      result = 0;
    }else if (i<0){
      result = widget.list.length - 1;
    }else{
      result = i;
    }
    return result;
  }

  Widget btnPrevious(){
    return IconButton(
        onPressed: (){
          setSong(getAudioIndex(widget.index - 1));
          advancedPlayer.play();
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
          setSong(getAudioIndex(widget.index + 1));
          advancedPlayer.play();
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
            setState(() {
              isRepeat = true;
              isAutoNext = false;
            });
          }
          else{
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
          advancedPlayer.play();
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
                      advancedPlayer.stop();
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
                        advancedPlayer.stop();
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
              height: screenHeight* .4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child:  Column(
                  children: [
                    SizedBox(height: screenHeight * .08,),
                    Text(widget.list[widget.index].title
                      ,style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(widget.list[widget.index].artist.toString()
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
                          Text(advancedPlayer.position.toString().split(".")[0], style: const TextStyle(fontSize: 16),),
                          Text(advancedPlayer.duration.toString().split(".")[0], style: const TextStyle(fontSize: 16),),
                        ],
                      ),
                    ),
                    slider(),

                    loadAsset(),
                  ],
                ),
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
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: QueryArtworkWidget(
                      id: widget.list[widget.index].id,
                      type: ArtworkType.AUDIO,
                      keepOldArtwork: true,
                      nullArtworkWidget: Image.asset('assets/img/voice_assistant.png')
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}