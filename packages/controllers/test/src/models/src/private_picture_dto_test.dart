// ignore_for_file: prefer_const_constructors

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('PrivatePictureDTO', () {
    late PrivatePictureDTO privatePictureDTO;
    setUp(() {
      privatePictureDTO = PrivatePictureDTO(id: 'id', key: 0);
    });

    test('can compare ', () {
      expect(privatePictureDTO, PrivatePictureDTO(id: 'id', key: 0));
    });
    test('can toJson and fromJson', () {
      final privatePictureDTOJsoned =
          PrivatePictureDTO.fromJson(privatePictureDTO.toJson());
      expect(privatePictureDTOJsoned, privatePictureDTO);
    });
  });
}
