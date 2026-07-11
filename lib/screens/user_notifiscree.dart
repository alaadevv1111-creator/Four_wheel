import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:four_wheels/controller/user_notificontroller.dart';
import 'package:four_wheels/models/notifi_usermodel.dart';

class UserNotificationsScreen extends StatelessWidget {
  const UserNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserNotificationController controller =
    Get.isRegistered<UserNotificationController>()
        ? Get.find<UserNotificationController>()
        : Get.put(UserNotificationController());

    // أول ما تفتح الصفحة، نعلم كل الإشعارات كمقروءة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.unreadCount.value > 0) {
        controller.markAllAsRead();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Color(0xff101828)),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.manrope(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff101828),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none_rounded,
                    size: 60.sp, color: Colors.grey.shade300),
                SizedBox(height: 16.h),
                Text(
                  'No notifications yet',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff64748B),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: ListView.separated(
            padding: EdgeInsets.all(20.w),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final UserNotificationModel n = controller.notifications[index];

              return Dismissible(
                key: ValueKey(n.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffFEE2E2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: const Icon(Icons.delete_outline, color: Color(0xffDC2626)),
                ),
                onDismissed: (_) => controller.deleteNotification(n.id),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: n.isRead ? Colors.white : const Color(0xffEFF6FF),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: n.isRead
                          ? const Color(0xffE2E8F0)
                          : const Color(0xffBFDBFE),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.h,
                        margin: EdgeInsets.only(top: 5.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: n.isRead
                              ? Colors.transparent
                              : const Color(0xff2563EB),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: GoogleFonts.manrope(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xff101828),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              n.message,
                              style: GoogleFonts.manrope(
                                fontSize: 13.sp,
                                color: const Color(0xff64748B),
                              ),
                            ),
                            if (n.createdAt.isNotEmpty) ...[
                              SizedBox(height: 8.h),
                              Text(
                                n.createdAt,
                                style: GoogleFonts.manrope(
                                  fontSize: 11.sp,
                                  color: const Color(0xff94A3B8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}