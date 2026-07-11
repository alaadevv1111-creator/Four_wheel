import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverOption {
  final String id;
  final String name;
  final String? imageUrl;
  final double rating;
  final int tripsCompleted;

  DriverOption({
    required this.id,
    required this.name,
    this.imageUrl,
    this.rating = 0.0,
    this.tripsCompleted = 0,
  });
}

class DriverDialogColors {
  static const Color navy = Color(0xff111827);
  static const Color navyLight = Color(0xff475467);
  static const Color gold = Color(0xffF5B93D);
  static const Color goldDark = Color(0xffE9A422);
  static const Color orange = Color(0xffF7941D);
  static const Color bgGrey = Color(0xffF7F8FC);
  static const Color textGrey = Color(0xff667085);
  static const Color star = Color(0xffFFB800);
}

class NoLicenseDriverDialog extends StatefulWidget {
  final List<DriverOption> drivers;
  final VoidCallback onAddLicense;

  const NoLicenseDriverDialog({
    super.key,
    required this.drivers,
    required this.onAddLicense,
  });

  @override
  State<NoLicenseDriverDialog> createState() => _NoLicenseDriverDialogState();

  static Future<DriverOption?> show(
      BuildContext context, {
        required List<DriverOption> drivers,
        required VoidCallback onAddLicense,
      }) {
    return showDialog<DriverOption>(
      context: context,
      barrierDismissible: true,
      builder: (_) => NoLicenseDriverDialog(
        drivers: drivers,
        onAddLicense: onAddLicense,
      ),
    );
  }
}

class _NoLicenseDriverDialogState extends State<NoLicenseDriverDialog> {
  DriverOption? selected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 460.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30.r,
                offset: Offset(0, 12.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 22.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your account has no verified driving license. Please select one of the available drivers for your booking dates.',
                      style: GoogleFonts.manrope(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                        color: DriverDialogColors.textGrey,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _driverList(),
                    SizedBox(height: 20.h),
                    _actionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 16.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            DriverDialogColors.gold,
            DriverDialogColors.orange,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Driving License Found',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'A driver must be selected to continue',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context, null),
            child: Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverList() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 260.h),
      child: Scrollbar(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.drivers.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final driver = widget.drivers[index];
            final bool isSelected = selected?.id == driver.id;

            return GestureDetector(
              onTap: () => setState(() => selected = driver),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: DriverDialogColors.bgGrey,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? DriverDialogColors.navy
                        : Colors.transparent,
                    width: 1.4,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: DriverDialogColors.navy,
                      backgroundImage: (driver.imageUrl != null &&
                          driver.imageUrl!.isNotEmpty)
                          ? NetworkImage(driver.imageUrl!)
                          : null,
                      child: (driver.imageUrl == null ||
                          driver.imageUrl!.isEmpty)
                          ? Icon(Icons.person,
                          color: Colors.white, size: 20.sp)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: GoogleFonts.manrope(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              color: DriverDialogColors.navy,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            '${driver.tripsCompleted} trips completed',
                            style: GoogleFonts.manrope(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: DriverDialogColors.textGrey,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < driver.rating.round()
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: 13.sp,
                                  color: DriverDialogColors.star,
                                );
                              }),
                              SizedBox(width: 6.w),
                              Text(
                                driver.rating.toStringAsFixed(1),
                                style: GoogleFonts.manrope(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: DriverDialogColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: driver.id,
                      groupValue: selected?.id,
                      activeColor: DriverDialogColors.navy,
                      onChanged: (_) => setState(() => selected = driver),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: selected == null
                ? null
                : () => Navigator.pop(context, selected),
            child: Container(
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selected == null
                      ? [Colors.grey.shade300, Colors.grey.shade300]
                      : [
                    DriverDialogColors.gold,
                    DriverDialogColors.goldDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Driver',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                      color: selected == null
                          ? Colors.grey.shade600
                          : DriverDialogColors.navy,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.check_rounded,
                    size: 17.sp,
                    color: selected == null
                        ? Colors.grey.shade600
                        : DriverDialogColors.navy,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: widget.onAddLicense,
            child: Container(
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    DriverDialogColors.navy,
                    DriverDialogColors.navyLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add License',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(Icons.badge_outlined,
                      size: 16.sp, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}