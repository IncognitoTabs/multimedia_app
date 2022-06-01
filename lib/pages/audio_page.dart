import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:multimedia_app/pages/detail_audio_page.dart';
import 'package:multimedia_app/pages/onboarding_page.dart';
import 'package:multimedia_app/pages/radio_page.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;
import 'package:flutter/material.dart';

import '../utils/app_tabs.dart';

class MyAudioPage extends StatefulWidget {
  const MyAudioPage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyAudioPageState createState() => _MyAudioPageState();
}

class _MyAudioPageState extends State<MyAudioPage> with SingleTickerProviderStateMixin {
  late List popularBooks;
  late List books ;
  late ScrollController _scrollController;
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                              children: const [
                                Icon(CupertinoIcons.search),
                                SizedBox(width: 10,),
                                Icon(Icons.notifications)
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
                    Container(
                        height: AppParams.swiperHeight,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: AppParams.swiperHeight,
                                child: PageView.builder(
                                    controller: PageController(viewportFraction: .8),
                                    itemCount: popularBooks == null
                                        ? 0 : popularBooks.length,
                                    itemBuilder: (_, i){
                                      return Container(
                                        height: AppParams.swiperHeight,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: AssetImage(popularBooks[i]["img"]),
                                                fit: BoxFit.contain
                                            )
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
                                    AppTabs(text: 'Trending', color: AppColors.menu3Color,),
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
                              itemCount: books == null? 0 :books.length,
                              itemBuilder: (_,i){
                                return
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailAudioPage(detailAudio: books, index: i,)));
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
                                                width: 90,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      image: AssetImage(books[i]["img"]),
                                                    )
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
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
                          const Material(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                              title: Text("Content"),
                            ),
                          ),
                          const Material(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                              title: Text("Content"),
                            ),
                          ),
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
    return Container(
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
                  MaterialPageRoute(builder: (context) => const OnBoardingPage()
                  )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.audiotrack_outlined),
            title: const Text('My Audio'),
            onTap: (){

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
