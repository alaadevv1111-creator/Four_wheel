import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// [CustomSectionCard] هي حاوية تنظيمية تُستخدم لتجميع حقول الإدخال ذات الصلة تحت عنوان وأيقونة واحدة.
/// تُضفي طابعاً منظماً وجمالياً (Grouped Style) على النماذج الطويلة.
class CustomSectionCard extends StatelessWidget {
  final String? title; // عنوان القسم (مثال: "المعلومات الشخصية")
  final IconData? icon; // الأيقونة الجانبية للعنوان
  final List<Widget> children; // قائمة الحقول التي ستظهر داخل هذه الحاوية

  const CustomSectionCard({super.key, this.title, this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: const Color(0xFF131B2E), size: 24.sp),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title!,
                      style: GoogleFonts.manrope(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
          ...children,
        ],
      ),
    );
  }
}

/// [SectionTextField] حقل نصي مخصص يتناسب مع تصميم التطبيق.
/// يحتوي على تسمية (Label) علوية، وإمكانية إضافة أيقونة بادئة (Prefix)، وعرض رسائل الخطأ.
class SectionTextField extends StatelessWidget {
  final String label; // النص الظاهر فوق الحقل
  final String hintText; // النص الإرشادي داخل الحقل
  final Widget? prefix; // ويدجت تظهر في بداية الحقل (مثل رمز العملة $)
  final bool isRequired; // هل الحقل إلزامي (يؤثر على شكل التسمية)
  final TextEditingController? controller; // المتحكم في النص
  final FocusNode? focusNode; // للتحكم في التركيز (Focus)
  final TextInputType? keyboardType; // نوع لوحة المفاتيح (أرقام، إيميل، إلخ)
  final String? errorText; // رسالة الخطأ التي تظهر أسفل الحقل عند التحقق

  const SectionTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefix,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
              width: 1.5.w,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            style: GoogleFonts.manrope(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.manrope(color: Colors.grey.shade400, fontSize: 16.sp),
              prefixIcon: prefix != null
                  ? Padding(padding: EdgeInsets.only(left: 20.w, right: 10.w), child: prefix)
                  : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 12.w),
            child: Text(
              errorText!,
              style: GoogleFonts.manrope(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

/// [SectionDropdownField] قائمة منسدلة مخصصة تعتمد على [GetX] لتحديث الحالة.
/// تتيح للمستخدم الاختيار من قائمة خيارات محددة مسبقاً بشكل جذاب.
class SectionDropdownField extends StatelessWidget {
  final String label; // التسمية العلوية
  final RxString rxValue; // القيمة المحددة (يجب أن تكون Rx للمراقبة بواسطة GetX)
  final List<String> options; // قائمة الخيارات (مثل: ["In Stock", "Out of Stock"])
  final bool isRequired; // هل الحقل إلزامي
  final String? errorText; // رسالة الخطأ

  const SectionDropdownField({
    super.key,
    required this.label,
    required this.rxValue,
    required this.options,
    this.isRequired = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired),
        Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
              width: 1.5.w,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: rxValue.value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: const Color(0xFF131B2E), size: 24.sp),
              borderRadius: BorderRadius.circular(20.r),
              dropdownColor: Colors.white,
              items: options.map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )
              )).toList(),
              onChanged: (val) => rxValue.value = val!,
            ),
          ),
        )),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 12.w),
            child: Text(
              errorText!,
              style: GoogleFonts.manrope(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

/// [SectionQuantityField] حقل ذكي لإدخال الكميات مع وحدات القياس.
/// يستخدم [RawAutocomplete] لاقتراح الوحدات (مثل units, kg) بمجرد كتابة الرقم.
class SectionQuantityField extends StatelessWidget {
  final String label; // التسمية العلوية
  final TextEditingController controller; // المتحكم في النص (يخزن الرقم والوحدة معاً)
  final List<String> units; // قائمة الوحدات المتاحة للاقتراح
  final String? errorText; // رسالة الخطأ
  final FocusNode? focusNode; // للتحكم في التركيز

  const SectionQuantityField({
    super.key,
    required this.label,
    required this.controller,
    required this.units,
    this.errorText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, true),
        LayoutBuilder(
          builder: (context, constraints) => RawAutocomplete<String>(
            textEditingController: controller,
            focusNode: focusNode ?? FocusNode(),
            optionsBuilder: (TextEditingValue textEditingValue) {
              // منطق الاقتراح: يبحث عن الوحدة بعد كتابة الرقم
              if (textEditingValue.text == '') return const Iterable<String>.empty();
              final match = RegExp(r'^(\d+)\s*(.*)$').firstMatch(textEditingValue.text);
              if (match == null) return const Iterable<String>.empty();
              final number = match.group(1) ?? '';
              final partialUnit = match.group(2) ?? '';
              if (partialUnit.isEmpty) return const Iterable<String>.empty();
              return units
                  .where((String option) => option.toLowerCase().startsWith(partialUnit.toLowerCase()))
                  .map((String option) => '$number $option');
            },
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: errorText != null ? Colors.red : Colors.transparent,
                    width: 1.5.w,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "e.g. 10 units",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  ),
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            options.elementAt(index),
                            style: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                          onTap: () => onSelected(options.elementAt(index)),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 12.w),
            child: Text(
              errorText!,
              style: GoogleFonts.manrope(
                color: Colors.red,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

/// [SectionToggleField] زر تبديل (Switch) مخصص للإعدادات الثنائية (تفعيل/تعطيل).
/// يعتمد على [GetX] لتحديث قيمة التفعيل فوراً.
class SectionToggleField extends StatelessWidget {
  final IconData icon; // الأيقونة التوضيحية
  final String title; // عنوان الإعداد
  final RxBool rxValue; // القيمة المنطقية (تستخدم GetX)

  const SectionToggleField({super.key, required this.icon, required this.title, required this.rxValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF131B2E), size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Obx(() => Switch(
            value: rxValue.value,
            onChanged: (val) => rxValue.value = val,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF131B2E),
          )),
        ],
      ),
    );
  }
}

/// دالة مساعدة لبناء الـ Label العلوي لكل حقل، مع مراعاة الحالة (إلزامي أو اختياري).
Widget _buildLabel(String label, bool isRequired) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
    child: Text(
      isRequired ? label.toUpperCase() : "$label (OPTIONAL)".toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 11.sp,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
        letterSpacing: 0.5,
      ),
    ),
  );
}
