import 'dart:convert';

import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_app/pages/home_page.dart';
import 'package:multimedia_app/pages/profile_page.dart';
import 'package:velocity_x/velocity_x.dart';
// ignore: library_prefixes
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;

import '../models/radio.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({Key? key}) : super(key: key);

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  late bool _isPlaying = false;
  late List radios;
  late MyRadio _selectedRadio;
  late AudioPlayer _audioPlayer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final suggestions =[
    '     Play     ',
    '     Stop     ',
    'Play rock music',
    'Play pop music',
    '  Play next   ',
    'Play 107 FM',
    'Play 104 FM',
    '   Pause   ',
    'Play previous',
    'How the weather today',
  ];
  @override
  void dispose(){
    super.dispose();
    _audioPlayer.dispose();
    AlanVoice.deactivate();
    AlanVoice.hideButton();
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchRadio();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      _isPlaying = event == AudioPlayerState.PLAYING ? true : false;
      setState(() {});
    });
    initAIButton();
  }

  initAIButton() {
    AlanVoice.addButton(
        "c7b2214dfec7e826b3f8d98632d54d1a2e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.activate();
    AlanVoice.callbacks.add((command) => handleCommand(command.data));
  }

  handleCommand(Map<String,dynamic> response) {
    switch(response["command"]){
      case "play":
        _audioPlayer.play(_selectedRadio.url);
        break;
      case "stop":
        _audioPlayer.stop();
        break;
      case "next":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if(index + 1 > radios.length){
          newRadio = radios.firstWhere((element) => element.id == 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }else{
          newRadio = radios.firstWhere((element) => element.id == index + 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      case "prev":
        final index = _selectedRadio.id;
        MyRadio newRadio;
        if(index - 1 <= 0){
          newRadio = radios.firstWhere((element) => element.id == radios.length);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }else{
          newRadio = radios.firstWhere((element) => element.id == index - 1);
          radios.remove(newRadio);
          radios.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      case "play_channel":
        final id = response["id"];
        _audioPlayer.pause();
        MyRadio newRadio = radios.firstWhere((element) => element.id == id);
        radios.remove(newRadio);
        radios.insert(0, newRadio);
        _playMusic(newRadio.url);
        break;
      default:
        break;
    }
  }

  fetchRadio() async {
    //Load data directly from json file
    // await DefaultAssetBundle.of(context).loadString("assets/json/radio.json").then((value){
    //   setState(() {
    //     radios = json.decode(value);
    //   });
    // });

    //Load data from json file through object model
    final radioJson = await rootBundle.loadString("assets/json/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios[0];
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      key: _scaffoldKey,
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
              child: Column(
                children: [
                  AppBar(
                    title: "Radio Player".text.xl2.bold.black.make(),
                    elevation: 0.0,
                    leading: IconButton(
                        icon: const ImageIcon(AssetImage("assets/img/menu.png"),size: 24, color: Colors.black,),
                        padding: const EdgeInsets.only(left: 15),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                          setState(() { });
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
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  "Call Assistant with - Hey Alan ".text.italic.semiBold.black.makeCentered(),
                  20.heightBox,
                  "Recommended command below".text.semiBold.black.makeCentered(),
                  10.heightBox,
                  VxSwiper.builder(
                      itemCount: suggestions.length,
                      height: 50,
                      viewportFraction: .5,
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      autoPlayCurve: Curves.bounceIn,
                      autoPlayAnimationDuration: 3.seconds,
                      itemBuilder: (context, index){
                        final s = suggestions[index];
                        return Chip(
                          label: s.text.make(),
                          backgroundColor: Vx.randomPrimaryColor,
                        );
                      }),
                ],
              )
          ),
          // ignore: unnecessary_null_comparison
          VxSwiper.builder(
            itemCount: radios.length,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index) => _selectedRadio = radios[index],
            itemBuilder: (context, index) {
              final rad = radios[index];

              return VxBox(
                  child: ZStack(
                    [
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: VxBox(
                          child: rad.category
                              .toString()
                              .text
                              .uppercase
                              .white
                              .make()
                              .px12(),
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
                            rad.name
                                .toString()
                                .text
                                .xl3
                                .white
                                .bold
                                .make(),
                            5.heightBox,
                            rad.tagline
                                .toString()
                                .text
                                .sm
                                .white
                                .semiBold
                                .make(),
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
                    image: NetworkImage(rad.image.toString()),
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
                _playMusic(rad.url);
              }).p16();
            },
          ).centered(),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_selectedRadio.name} FM"
                    .text
                    .black
                    .makeCentered(),
              Icon(
                _isPlaying ? CupertinoIcons.stop_circle : CupertinoIcons
                    .play_circle,
                color: Colors.black,
                size: 50.0,
              ).onInkTap(() {
                _isPlaying
                    ? _audioPlayer.stop()
                    : _playMusic(_selectedRadio.url);
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
      ),
    );
  }
}

