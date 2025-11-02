library flutter_summernote;

import 'package:image_picker/image_picker.dart';

abstract final class CameraHelper {
  static final ImagePicker instance = ImagePicker();

  static Future<XFile?> getImage(bool fromCamera) async {
    final picked = await instance.pickImage(
      source: (fromCamera) ? ImageSource.camera : ImageSource.gallery,
    );
    if (picked != null) {
      return XFile(picked.path);
    } else {
      return null;
    }
  }
}
