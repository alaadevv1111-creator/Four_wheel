/// Helper مركزي للتعامل مع مسارات الصور (محلي vs قادم من السيرفر).
/// كل الشاشات والويدجتس لازم تستخدم هاد الملف بدل ما يكون فيه منطق
/// متكرر ومختلف بكل ملف (هاد كان سبب المشكلة الأصلية).
class ImageHelper {
  /// دومين الباك إند - عدله هون فقط لو تغير الدومين بالمستقبل
  static const String baseUrl = 'https://reload-hug-monastery.ngrok-free.dev';

  /// هل هاد مسار ملف محلي على الجهاز (صورة جديدة اختارها المستخدم
  /// ولسا ما انرفعت)؟ مسارات الجهاز عالموبايل دايماً بتبدأ بـ "/"
  /// (مثال: /data/user/0/.../cache/xxx.jpg)
  static bool isLocalFile(String path) {
    final value = path.trim();
    if (value.isEmpty) return false;
    if (value.startsWith('http')) return false;
    return value.startsWith('/');
  }

  /// هل القيمة فاضية أو null فعلياً؟
  static bool isEmpty(String path) {
    final value = path.trim();
    return value.isEmpty || value == 'null';
  }

  /// يبني رابط كامل قابل للعرض (Image.network) من مسار قادم من الباك إند.
  /// لازم يستخدم بس مع مسارات السيرفر (مش المسارات المحلية).
  static String resolveServerUrl(String path) {
    final value = path.trim();

    if (isEmpty(value)) return '';

    // already a full URL
    if (value.startsWith('http')) return value;

    // شيل أي "/" بالأول حتى ما يصير دبل سلاش
    String cleanPath = value.startsWith('/') ? value.substring(1) : value;

    // شيل "storage/" لو كانت موجودة بالأصل حتى ما تتكرر
    if (cleanPath.startsWith('storage/')) {
      cleanPath = cleanPath.substring('storage/'.length);
    }

    return '$baseUrl/storage/$cleanPath';
  }
}