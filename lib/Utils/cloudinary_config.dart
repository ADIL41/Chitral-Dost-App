import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryConfig {
  static final CloudinaryPublic cloudinary = CloudinaryPublic(
    'dfbbmfoqo', // cloud name
    'flutter_profile_upload', // upload preset
    cache: false,
  );
}
