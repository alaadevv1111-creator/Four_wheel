import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/models/service_requestordermodel.dart';
import 'package:four_wheels/constants/colors.dart';

class AdminServiceRequestDetails extends StatelessWidget {
  final ServiceRequestModel request;

  const AdminServiceRequestDetails({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Color(0xff101828)),
        ),
        title: Text(
          'Service Request Details',
          style: GoogleFonts.manrope(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xff101828),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          _row('Request ID', '#${request.id}'),
          _row('Status', request.status),
          _row('Customer Name', request.customerName),
          _row('Phone', request.customerPhone),
          _row('Email', request.customerEmail),
          _row('Service', request.serviceName),
          _row('Vehicle', request.vehicleModel),
          _row('Date', request.date),
          _row('Time', request.time),
          _row('Location', request.location),
          _row('Issue', request.reportedIssue),
          _row('Mechanic', request.technicianName),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff64748B),
              )),
          SizedBox(height: 8.h),
          Text(value.isEmpty ? '-' : value,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              )),
        ],
      ),
    );
  }
}