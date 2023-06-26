import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infrearnclass/common/view/root_tab.dart';
import 'package:infrearnclass/common/view/splash_screen.dart';
import 'package:infrearnclass/restaurant/view/basket_screen.dart';
import 'package:infrearnclass/restaurant/view/restaurant_detail.dart';
import 'package:infrearnclass/user/model/user_model.dart';
import 'package:infrearnclass/user/provider/user_me_provider.dart';
import 'package:infrearnclass/user/view/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if(previous != next){
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: Root_Tab.routeName,
      builder: (_, __) => Root_Tab(),
      routes: [
        GoRoute(
          path: 'restaurant/:rid',
          name: RestaurantDetailScreen.routeName,
          builder: (_, state) => RestaurantDetailScreen(
              id: state.params['rid']!,
          ),
        ),
      ]
    ),
    GoRoute(
      path: '/basket',
      name: BasketScreen.routeName,
      builder: (_, state) => BasketScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
  ];

  void logout(){
    ref.read(userMeProvider.notifier).logout();
  }

  // splash screen
  // 앱 처음 시작시 토큰 존재여부 확인
  // 토큰에 따른 로그인화면 또는 메인화면으로 전환 판단
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';

    // 유저 정보가 없는데 로그인중이라면 그대로 페이지 유지
    // 만약 로그인중이 아니라면 로그인 페이지 이동
    if(user == null){
      return logginIn ? null : '/login';
    }

    // user가 null 이 아님

    // UserModel
    // 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SplashScreen이면 홈으로 이동
    if(user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError
    if(user is UserModelError){
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}