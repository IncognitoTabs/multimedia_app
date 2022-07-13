import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multimedia_app/utils/app_param.dart' as params;
import 'package:multimedia_app/widgets/profile_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildTop(),
          buildContent(),
        ],
      )
    );
  }

  Widget buildTop(){
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        buildCoverPhoto(),
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
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            )
        ),
        Positioned(
            top: 210,
            child: ProfileWidget(
                imagePath: params.avatarUrl,
                onClicked: (){}
            )
        ),
      ],
    );
  }

  Widget buildCoverPhoto() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Image.network(
          params.coverPhotoUrl,
          height: params.coverPhotoHeight,
          fit: BoxFit.cover,
      ),
    );
  }

  Widget buildContent() {
    return Positioned(
        top: 340,
        left: 0,
        right: 0,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Hoàng Minh Tài',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
          const Text(
            'Flutter Developer',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200
            ),
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialIcon(Icons.mail,() async {
                const toEmail = 'hoangminhtai2810@gmail.com';
                const subject = 'Feedback about Flutter project';
                const message = 'Hello Minh Tài!\n\n';

                const url = 'mailto:$toEmail?subject=${subject}&body=${message}';
                if(await canLaunch(url)) {
                    await launch(url);}
              }),
              const SizedBox(width: 12,),
              buildSocialIcon(FontAwesomeIcons.linkedin,() async {
                const String url = 'https://www.linkedin.com/in/incognitotabs';
                if(await canLaunch(url)) {
                  await launch(
                      url,
                  );
                }else{
                  throw "could not  load $url";
                }
              }),
              const SizedBox(width: 12,),
              buildSocialIcon(FontAwesomeIcons.github,() async {
                const String url = 'https://github.com/IncognitoTabs';
                if(await canLaunch(url)) {
                  await launch(url);
                }else{
                  throw "could not  load $url";
                }
              }),
              const SizedBox(width: 12,),
              buildSocialIcon(FontAwesomeIcons.facebook,() async {
                const String url = 'https://www.facebook.com/incognito.tabs/';
                if(await canLaunch(url)) {
                  await launch(
                      url,
                  );
                }else{
                  throw "could not  load $url";
                }
              }),
            ],
          ),
          const SizedBox(height: 16,),
          const Divider(),
          const SizedBox(height: 16,),
          buildAbout(),
        ]
    ),
    );
  }

  Widget buildAbout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'About',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16,),
          Text(
            'As a 3rd year student at UTC-HCMC majoring in Information Technology, I have knowledge of software development and understanding of several programming languages such as Dart with Flutter Framework, C# .NET, Java and Javascript.\n\n My goal is to give people a better life by developing technology solutions',
            style: TextStyle(
              fontSize: 18,
              height: 1.4
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSocialIcon(IconData iconData, VoidCallback onClicked ) {
    return CircleAvatar(
      radius: 25,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: onClicked,
          child: Center(child: Icon(iconData, size: 32,),),
        ),
      ),
    );
  }
}
