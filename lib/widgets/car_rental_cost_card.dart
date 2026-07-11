import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarRentalCostCard extends StatelessWidget {
  final String duration;
  final String totalCost;

  const CarRentalCostCard({
    super.key,
    required this.duration,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
      decoration: BoxDecoration(
        color: const Color(0xffEEF0F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('DURATION'),
          const SizedBox(height: 12),
          Text(
            duration,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: const Color(0xff101828),
            ),
          ),
          const SizedBox(height: 22),
          const Divider(color: Color(0xffD8DDE5)),
          const SizedBox(height: 18),
          _sectionTitle('TOTAL COST'),
          const SizedBox(height: 12),
          Text(
            totalCost,
            style: GoogleFonts.manrope(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 14,
        letterSpacing: 2.3,
        fontWeight: FontWeight.w900,
        color: const Color(0xff52617A),
      ),
    );
  }
}