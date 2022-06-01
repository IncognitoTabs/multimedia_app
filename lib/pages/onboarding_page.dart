import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:multimedia_app/pages/audio_page.dart';
import 'package:multimedia_app/pages/radio_page.dart';
import 'package:multimedia_app/utils/app_colors.dart' as AppColors;
import 'package:multimedia_app/utils/app_param.dart' as AppParams;

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Music Player',
              bodyWidget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Flexible(
                          child: Text('"Music should strike fire from the heart of man and bring tears from the eyes of woman"',),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text('-Beethoven-'),
                    ],
                  ),
                ],
              ),
              image: buildImage('assets/img/music_player.png'),
              decoration: getDecoration(),
            ),
            PageViewModel(
              title: 'Radio FM',
              bodyWidget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Flexible(
                        child: Text('"It is not true I had nothing on, I had the radio on"'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text('-Marilyn Monroe-'),
                    ],
                  ),
                ],
              ),
              image: buildImage('assets/img/radio.png'),
              decoration: getDecoration(),
            ),
            PageViewModel(
              title: 'Voice Assistant',
              bodyWidget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Flexible(
                        child: Text('"AI Goes Above and Beyond Our Human Intelligence"'),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text('-Eliezer Yudkowsky, AI Researcher-'),
                    ],
                  ),
                ],
              ),
              image: buildImage('assets/img/voice_assistant.png'),
              decoration: getDecoration(),
            ),
          ],
          done: const Text(
            'Start',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black
            ),
          ),
          onDone: (){ goToHome(context);},
          showSkipButton: true,
          skip: const Text('Skip',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black
            ),
          ),
          next: const Icon(
            Icons.arrow_forward,
            size: 30,
            color: Colors.black,
          ),
          dotsDecorator: getDosDecoration(),
          animationDuration: 500,
          onSkip: (){ goToHome(context);},
          globalBackgroundColor: AppColors.onBoardingBackground,
        )
    );
  }

  Widget buildImage(String path) {
    return Center(
      child: Image.asset(path, width: AppParams.imageOnBoardingWidth)
    );
  }

  PageDecoration getDecoration() {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold
      ),
      bodyTextStyle: const TextStyle(
        fontSize: 24,
      ),
      descriptionPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
      imagePadding: const EdgeInsets.all(24),
      pageColor: AppColors.onBoardingBackground
    );
  }

  DotsDecorator getDosDecoration() {
    return DotsDecorator(
      size: const Size(10,10),
      activeSize: const Size(22,10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      )
    );
  }

  void goToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyAudioPage()
        )
    );
  }
}
