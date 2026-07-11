import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/controller/user_dascontroller.dart';
import 'package:four_wheels/models/service_requestordermodel.dart';
import 'package:four_wheels/widgets/expert_technic.dart';
import 'package:four_wheels/widgets/reported_issu.dart';
import 'package:four_wheels/widgets/servies_overview.dart';
import 'package:four_wheels/widgets/service_requeststates.dart';
import 'package:four_wheels/widgets/user_bottomNavBar.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  final ServiceRequestModel request;

  const ServiceRequestDetailsScreen({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final UserDashboardController navController =
    Get.isRegistered<UserDashboardController>()
        ? Get.find<UserDashboardController>()
        : Get.put(UserDashboardController());

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8FAFC),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            size: 26,
            color: Color(0xff101828),
          ),
        ),
        titleSpacing: 4,
        title: Text(
          'Service Request Details',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 130),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceRequestStatusHeader(
              requestNumber: request.requestNumber,
              status: request.status,
            ),

            const SizedBox(height: 22),

            ServiceOverviewCard(
              title: request.serviceName,
              subtitle: request.vehicleModel,
              date: request.date,
              time: request.time,
              location: request.location,
            ),

            const SizedBox(height: 22),

            _sectionTitle('REPORTED ISSUE'),

            const SizedBox(height: 12),

            ReportedIssueCard(
              issue: request.reportedIssue,
            ),

            const SizedBox(height: 22),


          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => UserBottomNavBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeIndex,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 13,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w900,
        color: const Color(0xff64748B),
      ),
    );
  }
}