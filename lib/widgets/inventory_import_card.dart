import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:four_wheels/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// [InventoryImportCard] هي ويدجت مخصصة لعرض بطاقة "استيراد المخزون".
/// تُستخدم في شاشة الملحقات (Accessories) لتوفير خيار للمستخدم لرفع بيانات جماعية عبر ملفات CSV أو مسح الباركود.
/// تم تصميمها بشكل بصري جذاب مع أيقونة واضحة ونص وصفي لتسهيل تجربة المستخدم.
class InventoryImportCard extends StatelessWidget {
  /// الوظيفة التي سيتم تنفيذها عند النقر على البطاقة (مثل فتح نافذة اختيار الملفات).
  final VoidCallback onTap;

  const InventoryImportCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: const Color(0xFFEBEEF0), // لون خلفية رمادي فاتح لتمييز القسم عن باقي قائمة العناصر.
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            // حاوية الأيقونة: موضوعة داخل دائرة بيضاء لإبرازها كإجراء أساسي ومهم.
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Icons.add_box_outlined, size: 28.sp, color: AppColor.cardprim2),
            ),
            SizedBox(height: 16.h),
            // العنوان الرئيسي للبطاقة بخط Manrope عريض وواضح.
            Text(
              "Inventory Import",
              style: GoogleFonts.manrope(
                fontSize: 18.sp, 
                fontWeight: FontWeight.bold, 
                color: AppColor.primary
              ),
            ),
            SizedBox(height: 8.h),
            // نص وصفي يشرح للمستخدم الفائدة من هذا القسم بوضوح.
            Text(
              "Bulk upload CSV or scan barcodes to\nupdate stock quickly.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13.sp, 
                color: AppColor.bcolorsmalltitle,
                height: 1.5
              ),
            ),
          ],
        ),
      ),
    );
  }
}
