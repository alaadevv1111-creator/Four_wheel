import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:four_wheels/controller/review_bookingcontroller.dart';
import 'package:four_wheels/widgets/emp_avater.dart';

void showDriverSelectionDialog(
    BuildContext context,
    ReviewBookingController controller,
    ) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Available Driver',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff101828),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 330,
                child: controller.availableDrivers.isEmpty
                    ? const Center(
                  child: Text(
                    'No available drivers',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.separated(
                  itemCount: controller.availableDrivers.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final driver = controller.availableDrivers[index];
                    final selected =
                        controller.selectedDriver.value?.id == driver.id;

                    return GestureDetector(
                      onTap: () {
                        controller.selectDriver(driver);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? const Color(0xff344054)
                                : const Color(0xffE2E8F0),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            EmployeeAvatar(
                              imagePath: _driverImage(driver),
                              size: 52,
                              isCircle: true,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xff101828),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${driver.role} • ${driver.status}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: const Color(0xff344054),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.selectedDriver.value == null) {
                      Get.snackbar(
                        'Error',
                        'Please choose a driver',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    controller.professionalDriver.value = true;
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff344054),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Confirm Driver',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void showAddLicenseDialog(
    BuildContext context,
    ReviewBookingController controller,
    ) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Driving License',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff101828),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'License Number',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff101828),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.licenseNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter license number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'License Image',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xff101828),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: controller.pickLicenseImage,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffD9DEE3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.licenseImagePath.value.isEmpty
                        ? 'Choose file'
                        : controller.licenseFileName,
                    style: const TextStyle(
                      color: Color(0xff101828),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.addLicense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff344054),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    controller.isLoading.value ? 'Saving...' : 'Save License',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String _driverImage(dynamic driver) {
  try {
    final value = driver.imageUrl;
    if (value != null && value.toString().isNotEmpty) return value.toString();
  } catch (_) {}

  try {
    final value = driver.image;
    if (value != null && value.toString().isNotEmpty) return value.toString();
  } catch (_) {}

  return '';
}
