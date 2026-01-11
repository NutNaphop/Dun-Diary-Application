import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Uint8List? processImageInIsolate(Uint8List rawBytes) {
    final originalImage = img.decodeImage(rawBytes);
    if (originalImage != null) {
      final fixedImage = img.bakeOrientation(
        originalImage,
      ); // Rotate image from EXIF
      return img.encodeJpg(fixedImage); // Encode to jpg
    }
    return null;
  }
}
