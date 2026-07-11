import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:four_wheels/constants/colors.dart';
class RevenueCard extends StatelessWidget {
  final String amount;
  final String title;
  final IconData icon;
  final String middleWave;
  final String sideWave;

  const RevenueCard({
    super.key,
    required this.amount,
    required this.title,
    required this.icon,
    required this.middleWave,
    required this.sideWave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.cardprim,
              AppColor.cardprim2,
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                left: 22,
                right: 40,
                bottom: 20,

                child: Image.asset(
                  middleWave,
                  height: 60,
                  fit: BoxFit.fill,
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(
                  sideWave,
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: Colors.white, size: 30),
                     Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style:  TextStyle(
                            color: Color(0xff9CA3AF),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                         SizedBox(height: 8),
                        Text(
                          amount,
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}