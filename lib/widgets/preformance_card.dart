import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerformanceCard extends StatelessWidget {
  final String jobsCompleted;
  final String avgRating;
  final String iconPath;

   PerformanceCard({
    super.key,
    required this.jobsCompleted,
    required this.avgRating,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color:  Color(0xff101828),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
        Positioned(
        right: -25,
        bottom: -25,

          child: Image.asset(
            "assets/images/perico2.png",
            width: 145,
          ),
        ),


      Padding(
        padding:  EdgeInsets.all(24),


          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    child: Image.asset(iconPath, width: 18),
                  ),
                   SizedBox(width: 16),
                  Text(
                    "Performance",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: _performanceItem(
                      title: "JOBS COMPLETED",
                      value: Text(
                        jobsCompleted,
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,

                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child:_performanceItem(
                      title: "AVG RATING",
                      value: Row(
                        children: [
                        Text(avgRating,
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white
                          ),
                        ),
                          SizedBox(width: 6,),
                          Image.asset("assets/images/star.png")
                    ],
                      ),
                    ),
    ),




                ],
              ),
            ],
          ),
      )],
      ),
    );
  }

  Widget _performanceItem({
    required String title,
    required Widget value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 10,
            letterSpacing: 1,
            color: Colors.white60,
          ),
        ),
         SizedBox(height: 8),

          value,


      ],
    );
  }
}