import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// موديل بسيط لعرض السائق داخل الديالوج
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

/// الألوان المستخدمة بالديالوج - نفس هوية التطبيق (كحلي بدل موف)
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

/// الديالوج الرئيسي: "No Driving License Found"
/// بيرجع الـ DriverOption المختار عند الضغط على Confirm Driver عبر Navigator.pop(context, driver)
/// وبيرجع null إذا ضغط Cancel أو أغلق الديالوج.
///
/// [onAddLicense] لازم تفتح ديالوج AddDrivingLicenseDialog من طرفك (بره هالملف)
/// وترجع true إذا نجح الحفظ عشان الديالوج يقفل بشكل صحيح، أو تتحكم بالمنطق متل ما بدك.
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

  /// اختصار لعرض الديالوج
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your account has no verified driving license. Please select one of the available drivers for your booking dates.',
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: DriverDialogColors.textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _driverList(),
                    const SizedBox(height: 20),
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
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            DriverDialogColors.gold,
            DriverDialogColors.orange,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Driving License Found',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'A driver must be selected to continue',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
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
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 260),
      child: Scrollbar(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.drivers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final driver = widget.drivers[index];
            final bool isSelected = selected?.id == driver.id;

            return GestureDetector(
              onTap: () => setState(() => selected = driver),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: DriverDialogColors.bgGrey,
                  borderRadius: BorderRadius.circular(14),
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
                      radius: 20,
                      backgroundColor: DriverDialogColors.navy,
                      backgroundImage: (driver.imageUrl != null &&
                          driver.imageUrl!.isNotEmpty)
                          ? NetworkImage(driver.imageUrl!)
                          : null,
                      child: (driver.imageUrl == null ||
                          driver.imageUrl!.isEmpty)
                          ? const Icon(Icons.person,
                          color: Colors.white, size: 20)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: GoogleFonts.manrope(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: DriverDialogColors.navy,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${driver.tripsCompleted} trips completed',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: DriverDialogColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < driver.rating.round()
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  size: 13,
                                  color: DriverDialogColors.star,
                                );
                              }),
                              const SizedBox(width: 6),
                              Text(
                                driver.rating.toStringAsFixed(1),
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
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
              height: 48,
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
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Driver',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: selected == null
                          ? Colors.grey.shade600
                          : DriverDialogColors.navy,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.check_rounded,
                    size: 17,
                    color: selected == null
                        ? Colors.grey.shade600
                        : DriverDialogColors.navy,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: widget.onAddLicense,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    DriverDialogColors.navy,
                    DriverDialogColors.navyLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add License',
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.badge_outlined,
                      size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}