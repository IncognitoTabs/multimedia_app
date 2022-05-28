import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;

import '../utils/audio_file.dart';

class DetailAudioPage extends StatefulWidget {
  final detailAudio;
  final int index;

  const DetailAudioPage({Key? key, required this.detailAudio, required this.index}) : super(key: key);

  @override
  State<DetailAudioPage> createState() => _DetailAudioPageState();
}

class _DetailAudioPageState extends State<DetailAudioPage> {

  late AudioPlayer advancedPlayer;

  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
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
                  IconButton(
                    icon: const Icon(Icons.search,),
                    onPressed: (){

                    },
                  ),
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
                    AudioFile(advancedPlayer: advancedPlayer, path: widget.detailAudio[widget.index]["audio"],)
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
                        image: DecorationImage(
                          image: AssetImage(widget.detailAudio[widget.index]["img"]),
                          fit: BoxFit.cover
                        ),
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
