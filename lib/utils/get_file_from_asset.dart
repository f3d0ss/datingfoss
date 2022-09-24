import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class GetFileFromAsset {
  Future<File> getImageFileFromAssets(String path) async {
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    try {
      final byteData = await rootBundle.load('assets/$path');
      await file.writeAsBytes(
        byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    } catch (_) {}

    return file;
  }
}
