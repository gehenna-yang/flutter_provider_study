import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:infrearnclass/common/component/custom_text_form_field.dart';
import 'package:infrearnclass/common/const/colors.dart';
import 'package:infrearnclass/common/const/data.dart';
import 'package:infrearnclass/common/dio/dio.dart';
import 'package:infrearnclass/common/layout/default_layout.dart';
import 'package:infrearnclass/common/secure_storage/secure_storage.dart';
import 'package:infrearnclass/common/view/root_tab.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String userId = '';
  String userPwd = '';

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(height: 16),
                _SubTitle(),
                Image.asset('asset/img/misc/logo.png', width: MediaQuery.of(context).size.width/3*2,),
                CustomTextFormField(
                  hintText: "이메일을 입력해 주세요",
                  onChanged: (String value) {
                    userId = value;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: "비밀번호를 입력해 주세요",
                  onChanged: (String value) {
                    userPwd = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async { // login
                    try{
                      final rawString = '$userId:$userPwd';
                      Codec<String, String> stringToBase64 = utf8.fuse(base64);

                      String token = stringToBase64.encode(rawString);

                      final resp = await dio.post(
                        'http://$ip/auth/login',
                        options: Options(
                          headers: {
                            'authorization': 'Basic $token',
                          }
                        ),
                      );

                      print('token: $token\nresp: ${resp.data}');

                      final refreshtoken = resp.data['refreshToken'];
                      final accesstoken = resp.data['accessToken'];

                      final storage = ref.read(secureStorageProvider);

                      storage.write(key: ACCESS_TOKEN_KEY, value: accesstoken);
                      storage.write(key: REFRESH_TOKEN_KEY, value: refreshtoken);

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Root_Tab()),
                      );

                    }catch(e){
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('환영합니다!', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),);
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: BODY_TEXT_COLOR),);
  }
}