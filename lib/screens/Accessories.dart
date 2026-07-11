import 'package:flutter/material.dart';
import 'package:four_wheels/controller/dsa_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/Custom_Stat_Card.dart';
import '../widgets/Custom_Accessory_Card.dart';
import '../widgets/inventory_import_card.dart';
import '../widgets/accessory_helper_widgets.dart';
import '../widgets/ProfileAvatar.dart';
import 'add_accessories.dart';
import 'Accessories_Details.dart';
import 'General_admin_sitting.dart';
import 'Profile_admin_sitting.dart';
import '../services/AccessoryService.dart';
import 'package:four_wheels/widgets/custom_bttom_navbar.dart';


class AccController extends GetxController {
  var selectedIndex = 1.obs; 
  var isLoading = false.obs;
  final ScrollController scrollController = ScrollController();
  bool _hasScrolledForAddItem = false;

  RxList<dynamic> itemsList = <dynamic>[].obs;
  var totalUnitsCount = 0.obs;
  var totalStockValueAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    await Future.wait([fetchAccessories(), fetchStats()]);
  }

  Future<void> fetchAccessories() async {
    try {
      isLoading.value = true;
      final response = await AccessoryService.getAllAccessories();
      if (response['success'] == true) {
        itemsList.assignAll(response['data']);
      }
    } catch (e) {
      debugPrint("Error fetching accessories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStats() async {
    try {
      final partsRes = await AccessoryService.getTotalParts();
      if (partsRes['success'] == true) {
        totalUnitsCount.value = int.tryParse(partsRes['total_parts'].toString()) ?? 0;
      }
      
      final valueRes = await AccessoryService.getTotalValue();
      if (valueRes['success'] == true) {
        totalStockValueAmount.value = double.tryParse(valueRes['total_value'].toString()) ?? 0.0;
      }
    } catch (e) {
      debugPrint("Error fetching stats: $e");
    }
  }

  void handleTabPress(int index) {
    if (index == 1) {
      if (selectedIndex.value == 1 && _hasScrolledForAddItem) {
        Get.to(() => const AddAccessories())?.then((_) {
          _hasScrolledForAddItem = false;
          refreshData();
        });
      } else {
        selectedIndex.value = 1;
        _hasScrolledForAddItem = true;
        _scrollToBottom();
      }
    } else {
      selectedIndex.value = index;
      _hasScrolledForAddItem = false;
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutQuart,
        );
      }
    });
  }
}


class AccScrean extends StatelessWidget {
  const AccScrean({super.key});

  @override
  Widget build(BuildContext context) {
    final AccController controller = Get.put(AccController());
    final DashbordController dcontroller =
    Get.isRegistered<DashbordController>()
        ? Get.find<DashbordController>()
        : Get.put(DashbordController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColor.mainBc,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.secondary,
        toolbarHeight: 72.h,

        title: Text(
          'Accessories',
          style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xff0F172A)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () => Get.to(() => const generalprofilescreen()),
              child: ProfileAvatar(radius: 18.r, fontSize: 12.sp,),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => CustomStatCard(
                icon: Icons.inventory_2_outlined,
                title: "TOTAL UNITS",
                value: controller.totalUnitsCount.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                backgroundColor: Colors.white,
                iconBgColor: AppColor.txtColor1,
                iconColor: AppColor.cardprim2,
                valueColor: AppColor.primary,
                titleColor: AppColor.bcolorsmalltitle,
                borderRadius: 24.r,
              )),
              SizedBox(height: 16.h),
              Obx(() => CustomStatCard(
                icon: Icons.account_balance_wallet_outlined,
                title: "STOCK VALUE",
                value: "\$${controller.totalStockValueAmount.value.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                subtitle: "Estimated asset worth",
                gradient: const LinearGradient(begin: Alignment.bottomRight, end: Alignment.topLeft, colors: [AppColor.cardprim, AppColor.cardprim2]),
                iconBgColor: Colors.white.withAlpha(25),
                iconColor: Colors.white,
                valueColor: Colors.white,
                titleColor: Colors.white70,
                subtitleColor: Colors.white54,
                borderRadius: 24.r,
              )),
              SizedBox(height: 55.h),
              Text("Parts & Accessories", style: GoogleFonts.manrope(fontSize: 24.sp, fontWeight: FontWeight.w900, color: AppColor.primary)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  AccessoryTabButton(controller: controller, index: 0, text: "All Categories"),
                  SizedBox(width: 8.w),
                  AccessoryTabButton(controller: controller, index: 1, text: "Add Item", icon: Icons.add),
                ],
              ),
              SizedBox(height: 24.h),
              Obx(() {
                if (controller.isLoading.value && controller.itemsList.isEmpty) {
                  return const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 40), child: CircularProgressIndicator()));
                }

                if (controller.itemsList.isEmpty) {
                  if (controller.selectedIndex.value == 0) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Column(
                          children: [
                            Icon(Icons.inventory_outlined, size: 60.sp, color: Colors.grey),
                            SizedBox(height: 10.h),
                            Text("No accessories found", style: GoogleFonts.manrope(fontSize: 16.sp, color: AppColor.bcolorsmalltitle)),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.itemsList.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final item = controller.itemsList[index];
                    final quantity = int.tryParse(item['stock_quantity']?.toString() ?? '0') ?? 0;
                    final String currrentStatusText = item['status'] != null
                        ? item['status'].toString()
                        : AccessoryUtils.calculateStatus(quantity);

                    final StockStatus currrentStatus = mapStringToStockStatus(currrentStatusText);
                return GestureDetector(
                      onTap: () async {
                        // الانتظار عند العودة من صفحة التفاصيل لتحديث القائمة فوراً
                        await Get.to(() => AccessoriesDetails(id: item['id']));
                        controller.refreshData();
                      },
                      child: SizedBox(
                        height: 400.h,
                        child: CustomAccessoryCard(
                          imageUrl: item['photo_url'] ?? item['image'] ?? item['imageUrl'] ?? '',
                          category: item['category'] ?? "N/A",
                          title: item['name'] ?? item['item_name'] ?? "No Name",
                          sku: (item['part_id'] ?? item['sku'] ?? "No SKU").toString(),
                          stockStatus: currrentStatus,
                          quantity: quantity,
                          unit: item['unit'] is Map ? (item['unit']['name'] ?? "units") : (item['unit']?.toString() ?? "units"),
                          price: double.tryParse(item['price']?.toString() ?? '0.0') ?? 0.0,
                        ),
                      ),
                    );
                  },
                );
              }),
              Obx(() => controller.selectedIndex.value == 1
                  ? Column(
                children: [
                  SizedBox(height: 16.h),
                  InventoryImportCard(
                    onTap: () => Get.to(() => const AddAccessories())?.then((_) => controller.refreshData()),
                  ),
                ],
              )
                  : const SizedBox.shrink()),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: dcontroller.currentIndex.value,
          onTap: dcontroller.changeIndex,
        ),
      ),
    );
  }

}
StockStatus mapStringToStockStatus(String status) {
  final normalized = status.trim().toLowerCase();

  if (normalized.contains('out')) {
    return StockStatus.outOfStock;
  }
  if (normalized.contains('low')) {
    return StockStatus.lowStock;
  }
  return StockStatus.inStock;
}

