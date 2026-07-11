import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/widgets/custom_ratingstars.dart';

class DriverCarRatingCard extends StatelessWidget {
  final String carName;
  final String carImage;
  final String vin;
  final double? customerRating;

  const DriverCarRatingCard({
    super.key,
    required this.carName,
    required this.carImage,
    required this.vin,
    required this.customerRating,
  });

  @override
  Widget build(BuildContext context) {
    final hasRating = customerRating != null;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildCarImage(),
              Positioned(
                left: 20,
                bottom: 18,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'VIN: $vin',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Rating',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff45464D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (hasRating)
                        Row(
                          children: [
                            CustomRatingStars(
                              rating: customerRating!,
                              enabled: false,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              customerRating!.toStringAsFixed(1),
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xff191C1E),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Not rated yet',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xff94A3B8),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF1F2F4),
                  ),
                  child: const Icon(
                    Icons.directions_car_filled_outlined,
                    color: Color(0xff191C1E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage() {
    if (carImage.isEmpty) {
      return _placeholder();
    }

    if (carImage.startsWith('http')) {
      return Image.network(
        carImage,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (carImage.startsWith('assets/')) {
      return Image.asset(
        carImage,
        width: double.infinity,
        height: 190,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.file(
      File(carImage),
      width: double.infinity,
      height: 190,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 190,
      color: const Color(0xffE5E7EB),
      child: const Icon(
        Icons.directions_car_filled_outlined,
        size: 55,
        color: Color(0xff94A3B8),
      ),
    );
  }
}