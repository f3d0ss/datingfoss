import 'package:controllers/controllers.dart';
import 'package:models/models.dart';
import 'package:repositories/src/extensions/src/private_info_dto_extension.dart';
import 'package:repositories/src/extensions/src/public_info_dto_extension.dart';
import 'package:services/services.dart';

extension PartnerDTOExtension on UserDTO {
  Partner toPartner(
    SymmetricEncryptionService symmetricEncryptionService,
    List<String>? keys,
  ) {
    if (keys != null) {
      return Partner(
        username: username,
        publicInfo: publicInfo.toLocalPublicInfo(),
        privateInfo: privateInfo.toLocalPrivateInfo(
          encryptionService: symmetricEncryptionService,
          keys: keys,
          username: username,
        ),
        jsonPublicKey: publicKey,
      );
    }
    return Partner(
      username: username,
      publicInfo: publicInfo.toLocalPublicInfo(),
      jsonPublicKey: publicKey,
    );
  }
}
