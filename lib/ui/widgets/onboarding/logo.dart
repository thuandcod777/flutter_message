import 'package:flutter/material.dart';
import 'package:flutter_message/theme.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLightTheme(context)
          ? Image.asset('assets/logo_light.png', fit: BoxFit.fill)
          : Image.asset('assets/logo_dark.png', fit: BoxFit.fill),
    );
  }
}
