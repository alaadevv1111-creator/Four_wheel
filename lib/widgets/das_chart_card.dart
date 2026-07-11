import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:four_wheels/constants/colors.dart';
class RentalsOverTimeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isMonthly;
  final VoidCallback onMonthlyTap;
  final VoidCallback onWeeklyTap;
  final List<int> values;
  final int selectedIndex;
  final String selectedLabel;

  const RentalsOverTimeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isMonthly,
    required this.onMonthlyTap,
    required this.onWeeklyTap,
    required this.values,
    required this.selectedIndex,
    required this.selectedLabel,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = values.isEmpty
        ? 1
        : values.reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding:  EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppColor.bcolorsmalltitle,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color:  AppColor.backchart,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow:[
                      BoxShadow(
                      color: AppColor.bcolorbigtitle.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 4)

                  ),
                  ]
                  ),


               child:
               Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                 _Toggle(
                  text: "Monthly",
                  active: isMonthly,
                  onTap: onMonthlyTap,
                ),

                 SizedBox(width: 3),

                _Toggle(
                  text: "Weekly",
                  active: !isMonthly,
                  onTap: onWeeklyTap,
                ),
                ]),
                )],
            ),

            const SizedBox(height: 30),

            // 🔹 الشارت
            SizedBox(
              height: 216,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  final value = values[index];
                  final isSelected = index == selectedIndex;

                  final heightFactor =
                  maxValue == 0 ? 0.0 : value / maxValue;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        if (isSelected)
                          Container(
                            width: 100,
                            margin:  EdgeInsets.only(bottom: 8),
                            padding:  EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:  Color(0xff111827),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              selectedLabel,
                              style:  TextStyle(
                                color: Colors.white,
                                fontSize: 5,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        else
                           SizedBox(height: 28),


                        AnimatedContainer(
                          duration:  Duration(milliseconds: 250),
                          width: 35,
                          height: 176.0 * heightFactor,
                          decoration: BoxDecoration(
                            color: isSelected
                                ?  Color(0xff111827)
                                :  Color(0xffE5E7EB),

                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16)
                            ),
                            
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _Toggle({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ?  AppColor.bcolorbigtitle:  AppColor.backchart,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            color: active ? Colors.white : Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}