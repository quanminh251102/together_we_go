//import 'package:loviser/config/config.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';

final cloudinary = Cloudinary.signedConfig(
  apiKey: '948192272522128',
  apiSecret: 'jms91MYN0ZKY4X7t9E2t8GgRrXM',
  cloudName: 'dxoblxypq',
);

class ImageService {
  static Future<String> uploadFile(XFile file) async {
    final response = await cloudinary.upload(
        file: file.path,
        //fileBytes: file.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        //folder: cloudinaryCustomFolder,
        fileName: file.name,
        progressCallback: (count, total) {
          print('Uploading image from file with progress: $count/$total');
        });

    if (response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
      return response.secureUrl as String;
    }
    return "error";
  }
}
