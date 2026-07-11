import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class UploadController extends GetxController {
  final RxBool isUploading = false.obs;
  final Rxn<PlatformFile> selectedFile = Rxn<PlatformFile>();
  final imagePath = ''.obs;

  String get filePath {
    return selectedFile.value?.path ?? imagePath.value;
  }

  Future<void> pickImage() async {
    try {
      isUploading.value = true;

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      );

      if (result == null || result.files.isEmpty) return;

      selectedFile.value = result.files.first;
      imagePath.value = result.files.first.path ?? '';
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> pickFile() async {
    try {
      isUploading.value = true;

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result == null || result.files.isEmpty) return;

      selectedFile.value = result.files.first;
      imagePath.value = result.files.first.path ?? '';
    } finally {
      isUploading.value = false;
    }
  }

  void setImagePath(String path) {
    imagePath.value = path;
    selectedFile.value = null;
  }

  void clearFile() {
    selectedFile.value = null;
    imagePath.value = '';
  }
}
