import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class CustomAccessoryCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String sku;
  final StockStatus stockStatus;
  final int quantity;
  final String unit;
  final double price;

  const CustomAccessoryCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.sku,
    required this.stockStatus,
    required this.quantity,
    required this.unit,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Icon(
                          Icons.handyman_outlined,
                          size: 60.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF191C1E),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF191C1E),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildStockBadge(),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "SKU: $sku",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF45464D),
                    ),
                  ),
                  const Spacer(),
                  const Divider(height: 1, color: Color(0xFFECEEF0)),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "QUANTITY",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF45464D),
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "$quantity ",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w900,
                                    color: stockStatus == StockStatus.lowStock
                                        ? const Color(0xFFBA1A1A)
                                        : const Color(0xFF191C1E),
                                  ),
                                ),
                                TextSpan(
                                  text: unit,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF45464D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "PRICE",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF45464D),
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "\$${price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF131B2E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockBadge() {
    String label;
    Color bgColor;
    Color textColor;

    switch (stockStatus) {
      case StockStatus.inStock:
        label = "In Stock";
        bgColor = const Color(0xFF515F74);
        textColor = Colors.white;
        break;
      case StockStatus.lowStock:
        label = "Low Stock";
        bgColor = const Color(0xFFFFDAD6);
        textColor = const Color(0xFFBA1A1A);
        break;
      case StockStatus.outOfStock:
        label = "Out of Stock";
        bgColor = const Color(0xFFE6E8EA);
        textColor = const Color(0xFF45464D);
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}