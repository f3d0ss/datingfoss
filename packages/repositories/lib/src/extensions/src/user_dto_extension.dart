import 'package:controllers/controllers.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

extension FromUserDTOToLocalUser on UserDTO {
  LocalUser toLocalUser({
    required SymmetricEncryptionService encryptionService,
    required List<String> publicPics,
    required List<PrivatePic> privatePics,
  }) {
    return LocalUser(
      username: username,
      publicInfo: publicInfo.toLocalPublicInfo(pics: publicPics),
      privateInfo: privateInfo.toLocalPrivateInfo(
        encryptionService: encryptionService,
        keys: encryptionService.loadedKeys,
        username: username,
        pics: privatePics,
      ),
    );
  }
}
