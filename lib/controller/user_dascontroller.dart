import 'package:get/get.dart';

import 'package:four_wheels/screens/user_carScreen.dart';
import 'package:four_wheels/screens/user_bookingScreen.dart';


import 'package:four_wheels/screens/mechanic_dasscreen.dart';
import 'package:four_wheels/screens/user_dashboard.dart';
import 'package:four_wheels/screens/user_Accessories.dart';
import 'package:four_wheels/screens/user_profile_screen.dart';

class UserDashboardController extends GetxController {
  final currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;

    if (index == 0) {
      Get.offAll(() => const UserDashboard());
    } else if (index == 1) {
      Get.offAll(() => const UserCarsScreen());
    } else if (index == 2) {
      Get.offAll(() =>const UserBookingsScreen());
    } else if (index == 3) {
      Get.offAll(() =>const UserAccessoriesScreen() );
    } else if (index == 4) {
      Get.offAll(() => const UserProfileScreen());
    }
  }
}