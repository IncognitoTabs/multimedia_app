import 'dart:convert';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/cupertino.dart';
import 'package:multimedia_app/pages/detail_offline_audio_page.dart';
import 'package:multimedia_app/pages/detail_online_audio_page.dart';
import 'package:multimedia_app/pages/onboarding_page.dart';
import 'package:multimedia_app/pages/profile_page.dart';
import 'package:multimedia_app/pages/radio_page.dart';
// ignore: library_prefixes
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
// ignore: library_prefixes
import 'package:multimedia_app/utils/app_param.dart' as AppParams;
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/app_tabs.dart';
import 'audio_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late List popularBooks;
  late List books ;
  late List vietnameseSongs ;
  late List favouriteSongs ;
  late ScrollController _scrollController;
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: non_constant_identifier_names
  ReadData() async {
    await DefaultAssetBundle.of(context).loadString("assets/json/popularBooks.json").then((value){
      setState(() {
        popularBooks = json.decode(value);
      });
    });
    await DefaultAssetBundle.of(context).loadString("assets/json/books.json").then((value){
      setState(() {
        books = json.decode(value);
      });
    });
    await DefaultAssetBundle.of(context).loadString("assets/json/vietnameseSongs.json").then((value){
      setState(() {
        vietnameseSongs = json.decode(value);
      });
    });
    await DefaultAssetBundle.of(context).loadString("assets/json/favouriteSongs.json").then((value){
      setState(() {
        favouriteSongs = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: AppColors.background.withOpacity(.8),
        drawer: const NavigationDrawer(),
        key: _scaffoldKey,
        body: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 10, right: 20,),
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children:  [
                                IconButton(
                                  icon: const ImageIcon(AssetImage("assets/img/menu.png"),size: 24,),
                                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.notifications),
                                Container(
                                  width: 35,
                                  margin: const EdgeInsets.all(8),
                                  child: InkWell(
                                    child: const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(AppParams.avatarUrl),
                                    ),
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const ProfilePage()
                                          )
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: const Text("Popular",style: TextStyle(fontSize: 28)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                        height: AppParams.swiperHeight,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: SizedBox(
                                height: AppParams.swiperHeight,
                                child: VxSwiper.builder(
                                    itemCount: popularBooks.length,
                                    viewportFraction: .8,
                                    autoPlay: true,
                                    enableInfiniteScroll: true,
                                    autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                                    autoPlayAnimationDuration: 2.seconds,
                                    itemBuilder: (context, index){
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) => DetailOnlineAudioPage(detailAudio: popularBooks, index: index,)));
                                        },
                                        child: Container(
                                          height: AppParams.swiperHeight,
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.only(left: 15, right: 15),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: NetworkImage(popularBooks[index]["img"]),
                                                  fit: BoxFit.cover
                                              ),
                                              border: Border.all(
                                                style: BorderStyle.solid
                                              )
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        )
                    ),
                    Expanded(child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (BuildContext context, bool isScroll){
                        return[
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: AppColors.sliverBackground,
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(20),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 7.5),
                                child: TabBar(
                                  indicatorPadding: const EdgeInsets.all(0),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(.2),
                                          blurRadius:7,
                                          offset: const Offset(0,0),
                                        )
                                      ]
                                  ),
                                  tabs: [
                                    AppTabs(text: 'All', color: AppColors.menu1Color,),
                                    AppTabs(text: 'Favourite', color: AppColors.menu2Color,),
                                    AppTabs(text: 'Việt Nam', color: AppColors.menu3Color,),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          ListView.builder(
                              itemCount: books.length,
                              itemBuilder: (_,i){
                                return
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailOnlineAudioPage(detailAudio: books, index: i,)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left:20, right: 20, top:10, bottom: 10),
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
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(books[i]["img"]),
                                                      fit: BoxFit.fill
                                                    )
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, size: 22, color: AppColors.starColor,),
                                                      const SizedBox(width: 5,),
                                                      Text(books[i]["rating"], style: TextStyle(
                                                          color: AppColors.menu2Color, fontSize: 17),)
                                                    ],
                                                  ),
                                                  Text(books[i]["title"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                  Text(books[i]["text"], style: TextStyle(fontSize: 16, color: AppColors.subTitleText),),
                                                  Container(
                                                    width: 60,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: AppColors.loveColor
                                                    ),
                                                    child: const Text("Love", style: TextStyle(fontSize: 13, color: Colors.white),),
                                                    alignment: Alignment.center,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                              }),
                          ListView.builder(
                              itemCount: favouriteSongs.length,
                              itemBuilder: (_,i){
                                return
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailOnlineAudioPage(detailAudio: favouriteSongs, index: i,)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left:20, right: 20, top:10, bottom: 10),
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
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        image: NetworkImage(favouriteSongs[i]["img"]),
                                                        fit: BoxFit.fill
                                                    )
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, size: 22, color: AppColors.starColor,),
                                                      const SizedBox(width: 5,),
                                                      Text(favouriteSongs[i]["rating"], style: TextStyle(
                                                          color: AppColors.menu2Color, fontSize: 17),)
                                                    ],
                                                  ),
                                                  Text(favouriteSongs[i]["title"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                  Text(favouriteSongs[i]["text"], style: TextStyle(fontSize: 16, color: AppColors.subTitleText),),
                                                  Container(
                                                    width: 60,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: AppColors.loveColor
                                                    ),
                                                    child: const Text("Love", style: TextStyle(fontSize: 13, color: Colors.white),),
                                                    alignment: Alignment.center,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                              }),
                          ListView.builder(
                              itemCount: vietnameseSongs.length,
                              itemBuilder: (_,i){
                                return
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailOnlineAudioPage(detailAudio: vietnameseSongs, index: i,)));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left:20, right: 20, top:10, bottom: 10),
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
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        image: NetworkImage(vietnameseSongs[i]["img"]),
                                                        fit: BoxFit.fill
                                                    )
                                                ),
                                              ),
                                              const SizedBox(width: 20,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, size: 22, color: AppColors.starColor,),
                                                      const SizedBox(width: 5,),
                                                      Text(vietnameseSongs[i]["rating"], style: TextStyle(
                                                          color: AppColors.menu2Color, fontSize: 17),)
                                                    ],
                                                  ),
                                                  Text(vietnameseSongs[i]["title"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                  Text(vietnameseSongs[i]["text"], style: TextStyle(fontSize: 16, color: AppColors.subTitleText),),
                                                  Container(
                                                    width: 60,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(3),
                                                        color: AppColors.loveColor
                                                    ),
                                                    child: const Text("Love", style: TextStyle(fontSize: 13, color: Colors.white),),
                                                    alignment: Alignment.center,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                              }),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItem(context),
          ],
        ),
      )
    );
  }

  Widget buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnBoardingPage()
            )
        );
      },
      child: Container(
        padding: EdgeInsets.only(top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
        color: AppColors.menu3Color.withOpacity(.7),
        child: Column(
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(AppParams.avatarUrl),
            ),
            SizedBox(height: 12,),
            Text(
              'Hoàng Minh Tài',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
            Text(
              '6051071102@st.utc2.edu.vn',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.audiotrack_outlined),
            title: const Text('My Audio'),
            onTap: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AudioPage()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.radio_outlined),
            title: const Text('My FM'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const RadioPage()
                )
              );
            }
          ),
          const Divider(color: Colors.black45,),
          ListTile(
            leading: const Icon(Icons.info_outlined),
            title: const Text('About'),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Setting'),
            onTap: (){

            },
          ),
        ],
      ),
    );
  }
}
