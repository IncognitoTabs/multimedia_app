import 'package:flutter/material.dart';
import 'package:multimedia_app/utils/app_param.dart' as AppParams;

class AppTabs extends StatelessWidget {
  final Color color;
  final String text;

  const AppTabs({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppParams.buttonWidth,
      height: AppParams.buttonHeight,
      child: Text(
        text, style: TextStyle(color: Colors.white, fontSize: 17),
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius:7,
                offset: Offset(0,0)
            )
          ]
      ),
    );
  }
}
