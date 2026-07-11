import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:four_wheels/models/avilable_drivermodel.dart';

class AvailableDriversSheet extends StatelessWidget {
  final List<AvailableDriverModel> drivers;
  final RxnString selectedDriverId;
  final ValueChanged<String> onSelectDriver;
  final VoidCallback onContinue;

  /// Shown only when this sheet is opened from the "Book Now" flow for a
  /// user with no license on file. When provided, an "Add My License
  /// Instead" text button appears under the main action.
  final VoidCallback? onAddLicenseInstead;

  /// Shows the amber "No driving license found" notice at the top,
  /// matching the same warning shown on the website.
  final bool showNoLicenseNotice;

  const AvailableDriversSheet({
    super.key,
    required this.drivers,
    required this.selectedDriverId,
    required this.onSelectDriver,
    required this.onContinue,
    this.onAddLicenseInstead,
    this.showNoLicenseNotice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xffCBD5E1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Choose Available Driver',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: const Color(0xff101828),
              ),
            ),

            if (showNoLicenseNotice) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xffFDE68A)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xffB45309),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No driving license found on your account. Please select a driver, or add your license instead.',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 22),

            if (drivers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'No available drivers for these dates',
                  style: GoogleFonts.manrope(color: const Color(0xff64748B)),
                ),
              )
            else
              ...drivers.map(
                    (driver) => Obx(() {
                  final isSelected = selectedDriverId.value == driver.id;

                  return GestureDetector(
                    onTap: () => onSelectDriver(driver.id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xffEEF4FF)
                            : const Color(0xffF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xff334155)
                              : const Color(0xffE5E7EB),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: _driverImage(driver.image),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xff101828),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '${driver.totalTrips} trips completed',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff64748B),
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xffF59E0B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      driver.evaluation.toStringAsFixed(1),
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xff101828),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: const Color(0xff334155),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: onContinue,
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xff334155),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Continue Booking',
                    style: GoogleFonts.manrope(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            if (onAddLicenseInstead != null) ...[
              const SizedBox(height: 14),
              TextButton(
                onPressed: onAddLicenseInstead,
                child: Text(
                  'Add My License Instead',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff334155),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _driverImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 58,
        height: 58,
        fit: BoxFit.cover,
      );
    }

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        width: 58,
        height: 58,
        fit: BoxFit.cover,
      );
    }

    if (image.isNotEmpty) {
      return Image.file(
        File(image),
        width: 58,
        height: 58,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 58,
      height: 58,
      color: const Color(0xffE5E7EB),
      child: const Icon(
        Icons.person,
        color: Color(0xff94A3B8),
      ),
    );
  }
}
