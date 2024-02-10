import 'package:get/get.dart';
import 'package:notes_app/Routes/app_route_const.dart';
import 'package:notes_app/Ui/Auth/Login.dart';
import 'package:notes_app/Ui/Auth/Splash_screen.dart';
import 'package:notes_app/Ui/HomeScreen/homeScreen.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      transition: Transition.fadeIn,
      name: Routes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: Routes.INITIAL,
      page: () => const SplashScreen(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
    ),
  ];
}
