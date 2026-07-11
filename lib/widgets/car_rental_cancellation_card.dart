import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarRentalCancellationCard extends StatelessWidget {
  const CarRentalCancellationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffFCA5A5).withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Booking Cancellation',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(
                Icons.timer_outlined,
                color: Color(0xffDC2626),
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Booking cancellation may only be cancelled within 24 hours of placement.',
            style: GoogleFonts.manrope(
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: const Color(0xff45464D),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffFEF2F2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text(
                '12 Hours Remaining',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xffDC2626),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}