import 'package:flutter/material.dart';
import 'package:four_wheels/screens/splash_screen.dart';

import 'package:get/get.dart';

import 'controller/emp_control.dart';
import 'controller/car_controller.dart';
import 'controller/user_ordercontroller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: تأكدي من المسار الصحيح لأول صفحة بالتطبيق (سبلاش/لوجن) وبدّلي
// الاستيراد + الكلاس تحت بالاسم الصح عندك.
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  Get.put(EmployeeController(), permanent: true);
  Get.put(CarController(), permanent: true);
  Get.put(UserOrdersController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // بدل initialRoute + getPages الفاضية يلي كانت عم تكسر التطبيق،
          // منحدد أول صفحة مباشرة بـ home. المشروع كله أصلاً بيستخدم
          // Get.to(() => Widget()) مش named routes، فما في داعي أصلاً
          // لـ initialRoute/getPages.
          home:SplashScreen(),
        );
      },
    );
  }
}