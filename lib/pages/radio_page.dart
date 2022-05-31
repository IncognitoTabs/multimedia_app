import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_app/pages/audio_page.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;

class RadioPage extends StatefulWidget {
  const RadioPage({Key? key}) : super(key: key);

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  late bool _isPlaying = false;
  late List radios;
  late String channelName;
  late String channelUrl;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchRadio();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      _isPlaying = event == AudioPlayerState.PLAYING ? true:false ;
      setState(() {});
    });
  }

  fetchRadio() async {
    // final radioJson = await rootBundle.loadString("assets/radio.json");
    // radios = MyRadioList.fromJson(radioJson).radios;
    // setState(() {});
    await DefaultAssetBundle.of(context).loadString("assets/json/radio.json").then((value){
      setState(() {
        radios = json.decode(value);
      });
    });
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
            colors: [
              AppColors.audioBluishBackground,
              AppColors.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ))
              .make(),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                title: "Radio Player".text.xl2.bold.black.make(),
                elevation: 0.0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
                    onPressed: () {
                      _audioPlayer.stop();
                      Navigator.of(context).pop();
                    }
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              )
          ),
          // ignore: unnecessary_null_comparison
          VxSwiper.builder(
            itemCount: radios.length,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            itemBuilder: (context, index) {
              return VxBox(
                  child: ZStack(
                    [
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: VxBox(
                          child: radios[index]["category"].toString().text.uppercase.white.make().px12(),
                        )
                            .height(40)
                            .black
                            .alignCenter
                            .withRounded(value: 5.0)
                            .make(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VStack(
                          [
                            radios[index]['name'].toString().text.xl3.white.bold.make(),
                            5.heightBox,
                            radios[index]['tagline'].toString().text.sm.white.semiBold.make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: [
                            const Icon(
                              CupertinoIcons.play_circle,
                              color: Colors.white,
                            ),
                            10.heightBox,
                            "Double tap to play".text.gray300.make(),
                          ].vStack())
                    ],
                  ))
                  .clip(Clip.antiAlias)
                  .bgImage(
                DecorationImage(
                    image: NetworkImage(radios[index]['image'].toString()),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken)
                ),
              )
                  .border(color: Colors.black, width: 2.0)
                  .withRounded(value: 30.0)
                  .make()
                  .onInkDoubleTap(() {
                _playMusic(radios[index]['url'].toString());
                setState(() {
                  channelName = radios[index]["name"].toString();
                  channelUrl = radios[index]["url"].toString();
                });
              })
                  .p16();
            },
          ).centered(),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - $channelName FM"
                    .text
                    .black
                    .makeCentered(),
              Icon(
                _isPlaying ? CupertinoIcons.stop_circle: CupertinoIcons.play_circle,
                color: Colors.black,
                size: 50.0,
              ).onInkTap(() {
                _isPlaying
                    ?_audioPlayer.stop()
                    :_playMusic(channelUrl);
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
      ),
    );
  }
}
