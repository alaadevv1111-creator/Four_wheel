import 'package:flutter/material.dart';
import 'package:four_wheels/constants/colors.dart';
class DashboardInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Widget? child;

  const DashboardInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 2,
      color: AppColor.colorbackexport,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),

      ),
      child: Padding(
        padding:  EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 Top Row
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColor.txtColor1,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color:  Color(0xff6B7280),
                  ),
                ),

                 Spacer(),

                Text(
                  title.toUpperCase(),
                  style:  TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff9CA3AF),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Value
            Text(
              value,
              style:  TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xff111827),
              ),
            ),

            if (child != null) ...[
              const SizedBox(height: 14),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}