import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:multimedia_app/pages/home_page.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

import 'detail_offline_audio_page.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<SongModel> songs = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  void requestStoragePermission() async{
    if(!kIsWeb){
      bool permissionState = await _audioQuery.permissionsStatus();
      if(!permissionState){
        await _audioQuery.permissionsRequest();
      }
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.audioBluishBackground,
      drawer: const NavigationDrawer(),
      key: _scaffoldKey,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                leading: IconButton(
                    icon: const ImageIcon(AssetImage("assets/img/menu.png"),size: 24,),
                    padding: const EdgeInsets.only(left: 15),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    }
                ),
                actions: [
                  Container(
                    width: 35,
                    margin: const EdgeInsets.all(8),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(AppParams.avatarUrl),
                    ),
                  ),
                ],
                backgroundColor: AppColors.audioBlueBackground,
                shadowColor: Colors.transparent,
                title: Text('My Music'),
              )
          ),
          FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: SongSortType.DATE_ADDED,
              orderType: OrderType.DESC_OR_GREATER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item){
              if(item.data == null) {
                return const Center(child: CircularProgressIndicator(),);
              }
              if(item.data!.isEmpty){
                return const Center(child: Text("No Songs Found"),);
              }

              songs.clear();
              songs = item.data!;
              return Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ListView.builder(
                      itemCount: item.data!.length,
                      itemBuilder: (_,i){
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailOfflineAudioPage(list: songs, index: i,)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left:20, right: 20, top:0, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.tabBarViewColor,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        offset: const Offset(0,0),
                                        color: Colors.grey.withOpacity(.2)
                                    )
                                  ]
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child:  QueryArtworkWidget(
                                        id: item.data![i].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: Image.asset('assets/img/voice_assistant.png'),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.data![i].title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                            Text(item.data![i].artist.toString(), style: TextStyle(fontSize: 16, color: AppColors.subTitleText),),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
              );
            },
          ),
        ],
      ),
    );
  }
}
