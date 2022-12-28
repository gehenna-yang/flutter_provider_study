
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/common/secure_storage/secure_storage.dart';
import 'package:infrearnclass/common/view/root_tab.dart';
import 'package:infrearnclass/user/view/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {



  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    checkToken();
  }

  void deleteToken() async{
    final storage = ref.read(secureStorageProvider);
    await storage.deleteAll();
  }

  void checkToken() async{
    final storage = ref.read(secureStorageProvider);
    final accesstoken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshtoken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    try {
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
            headers: {
              'authorization': 'Bearer $refreshtoken',
            }
        ),
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Root_Tab()), (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen(),), (route) => false,
      );
    }

  }
}
