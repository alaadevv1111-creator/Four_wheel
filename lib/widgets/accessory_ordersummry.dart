import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccessoryOrderSummaryCard extends StatelessWidget {
  final String orderId;
  final String orderDate;
  final String quantity;
  final String unitPrice;
  final String totalAmount;

  const AccessoryOrderSummaryCard({
    super.key,
    required this.orderId,
    required this.orderDate,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 26.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Order ID',
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  color: const Color(0xff45464D),
                ),
              ),
              const Spacer(),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    orderId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const Divider(color: Color(0xffEEF0F3)),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  title: 'ORDER DATE',
                  value: orderDate,
                ),
              ),
              Expanded(
                child: _smallInfo(
                  title: 'QUANTITY',
                  value: quantity,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _smallInfo(
                  title: 'UNIT PRICE',
                  value: unitPrice,
                ),
              ),
              Expanded(
                child: _smallInfo(
                  title: 'TOTAL AMOUNT',
                  value: totalAmount,
                  alignEnd: true,
                  isBold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo({
    required String title,
    required String value,
    bool alignEnd = false,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 10.sp,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w900,
            color: const Color(0xff45464D),
          ),
        ),
        SizedBox(height: 10.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: isBold ? 22.sp : 16.sp,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}