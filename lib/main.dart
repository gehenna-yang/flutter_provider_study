import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/component/custom_text_form_field.dart';
import 'package:infrearnclass/common/view/splash_screen.dart';
import 'package:infrearnclass/user/view/login_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans'
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen(),
      ),
    );
  }


}