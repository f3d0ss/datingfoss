import 'dart:io';
import 'dart:math';

import 'package:controllers/controllers.dart';
import 'package:http/http.dart' as http;

class MockRestDiscoverController extends DiscoverController {
  MockRestDiscoverController({
    required String directoryToStoreFiles,
  }) : _directoryToStoreFiles = directoryToStoreFiles;

  final String _directoryToStoreFiles;
  final Map<String, String> cacheImage = {};
  int counter = 0;
  final _mockPartners = [
    UserDTO(
      username: 'eddy97',
      publicInfo: PublicInfoDTO(
        sex: 0,
        searching: const RangeValuesDTO(0, 0),
        textInfo: const {
          'name': 'Edward',
          'surname': 'Showden',
          'occupation': 'Whistle blower'
        },
        dateInfo: {'birthdate': DateTime.fromMicrosecondsSinceEpoch(1)},
        boolInfo: const {'fake': true},
        interests: const <String>[
          'Computers',
          'Privacy',
          'Paperelle',
          'Abracadabra',
          'ThisIsAVeryLongAndBoringInterest'
        ],
        bio: '''
American former computer intelligence consultant who leaked highly classified information from the National Security Agency (NSA) in 2013, when I was an employee and subcontractor. My disclosures revealed numerous global surveillance''',
        pictures: const [
          'https://www.rollingstone.com/wp-content/uploads/2018/06/rs-19540-20140528-snowden-x1800-1401297506.jpg?crop=900:600&width=440',
          'https://redpillvideotube.com/wp-content/uploads/2021/05/Edward-Snowden-960x960.jpg',
          'https://images-na.ssl-images-amazon.com/images/I/A1opZLgQdoL.jpg',
          'https://www.nybooks.com/wp-content/uploads/2017/01/snowden_edward-020917.jpg'
        ],
        location: const LocationDTO(12, 12),
      ),
      privateInfo: const PrivateInfoDTO(),
      publicKey: <String, dynamic>{
        'modulus':
            'x9OK0Yk5E+aOLjtpuoXwS8omhPuOZTgDAeWf2taMYpnQRhcO3jiEqGBLsBAX+sYmpENV2DF22fRNNH40yRa9voUIPFsU4q4BEI1KqF3OadBZuX8Obc4dPKkaFWkYepABon/z6isPussjMYH3uyolKKBH5HPB+Y4EXKqAnW54dGc=',
        'exponent': 'AQAB'
      },
    ),
    UserDTO.fromJson(<String, dynamic>{
      'username': 'mark88',
      'publicInfo': {
        'sex': 0.0,
        'searching': {'start': 0.5, 'end': 1.0},
        'textInfo': {
          'name': 'Mark',
          'surname': 'Zucca',
          'occupation': 'Monopolis expert'
        },
        'dateInfo': {'first kill': '1970-01-01T01:00:00.000001'},
        'boolInfo': {'fake': true, 'evil': true},
        'bio': """
I'm an American media magnate, internet entrepreneur, and philanthropist. I'm known for co-founding the social media website Facebook and its parent company Meta Platforms, of which he is the chairman, chief executive officer, and controlling shareholder.""",
        'interests': [
          'Computers',
          'Data of everyone',
          'Paperelle',
          'Abracadabra',
          'Surf'
        ],
        'pictures': <String>[
          'https://assets.wired.com/photos/w_1720/wp-content/uploads/2017/02/MarkZuckerberg.jpg',
          'https://d.ibtimes.co.uk/en/full/163878/founder-ceo-facebook-mark-zuckerberg.jpg?w=736',
          'https://www.masslive.com/resizer/LjWhkW2TK2HTPfkIZXDbL7fHnvg=/1280x0/smart/advancelocal-adapter-image-uploads.s3.amazonaws.com/image.masslive.com/home/mass-media/width2048/img/business-news/photo/mark-zuckerberg-548a49a5a9a3bbbb.jpg',
          'https://ruinmyweek.com/wp-content/uploads/2020/05/mark-zuckerberg-haircut-meme-2.jpg'
        ]
      },
      'privateInfo': {
        'textInfo': {
          'encoded': 'OHRJ20shI8wZ0qQ2Wai2hSprBJGsf14BZmVTUCAeuM4=',
          'keyIndex': 0
        },
        'dateInfo': {'encoded': 'OCs0sCZdSLY3vdlLd9XR8Q==', 'keyIndex': 0},
        'boolInfo': {'encoded': 'OCs0sCZdSLY3vdlLd9XR8Q==', 'keyIndex': 0},
        'bio': {'encoded': 'YXQ0sCZdSLY3vdlLd9XR8Q==', 'keyIndex': 0},
        'interests': {'encoded': 'GAs0sCZdSLY3vdlLd9XR8Q==', 'keyIndex': 0}
      },
      'publicKey': {
        'exponent': 'AQAB',
        'modulus':
            'l+RSyTYFzNxzyBro9je1saTK1rDhCdinIYnu7ljtLM98RuTabhY8k/vrnc/HHUjRS3HqbvmgkiR5PQBmS6yhJ/ax+7akAnhvzIk2RYjoA18Cvy5qGqP8FkgQ9hcUnX2mSr1cZ+Muauij7HQE9dwX57kaxtSZPS7CEskm6oUxLBfSoQQ0R83PxKfsiE9VHQ2h4AijlOkkIk0EXo0cZaurEi0h7R0LxMNYRzM68pAKZ+tUl1ykTfFAjS2EI9HODti3+CQikuaWkBz+P3LvqpcwmFEKZ6gCvmN+QfQu/+0uUMPP+yEtslq42VbEIYGk1/Kg9+aTVQO4+THHpgcDRVb2Zw=='
      },
      'encryptedKeys':
          'cUDre+bcA/p6XjOkaU4aY4C4SZ242lHR9mxqpfonFkRS4ebDo13ZUgMr9Op8RmBvAECa+Mr8fNT7lR2Cnba8ds1aKxtq2XCl+fZEwm6eKFfUotmeSCMsNGBCdrLxaeSGOEai9Csw6xFtjdhxAHCUQBWqsbtoonAx/LMwPWZfDc4sD25J9exgymkFcTQlFzOzDESgM/1Nys6+JSXaHXfnTyXevm60fpszlw/aIfZLRSpSrHKe18kBMbZB015iFF+6tgRzYoiDTQLw8+XRVDs/UcFddRU/qFFLs5zPz3BniPYQsrcz1bg7cxHPVa33vLRVoZEdDhfkFI4iu4vltWz9sA==',
      'encryptedPartnerThatILike':
          'i67ruhiK9v1WRgLJMnTMhZgy7HnKNaNHNWok+iqUKQl4YS/1f1LocXLQshcDgRJqSWjd1C6Rq2YzlMtSbP3mKoOLIpf1i/5pjt94KZcnpif2GMx96K7xWBD6VrxK9/dVa4QVvgNVdmCKF2J4wdVxnMjbmeY4ivBOsDjuAnjGWoo8j7cTicIdLDOHBg6wLahzbf9NUpC0yjaKhJUVW/nRWna/m7+gAId4MiS5FpJrUTLznz3gqBsn0N2IIqkSKXISQgnxti+I0b4784hzkwi+NQwFcyYOJ0FTd/VlrPiVpt6W9QQu73cRCxUWrtqmx5r6YN817gnUygNGaI/rq4d1xw=='
    }),
  ];

  @override
  Future<List<UserDTO>> fetchPartners({
    int numberOfPartner = 2,
    List<String> alreadyFetchedUsers = const [],
    dynamic options,
  }) async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    final partners = _createMockUsers(numberOfPartner, alreadyFetchedUsers);
    return partners;
  }

  @override
  Future<void> sendSealedLikeMessage({
    required String to,
    required String sealedLikeMessage,
  }) async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
  }

  @override
  Future<File> fetchPartnerPublicPicture({
    required String username,
    required String id,
  }) async {
    final intId = int.tryParse(id);
    if (intId != null) {
      final userNumber =
          int.parse(username.substring(username.length - 17, username.length));
      final firstImageURL = userNumber % images.length;
      if (intId == 0) {
        return urlToFile(images[firstImageURL]);
      }
      return urlToFile(otherImages[int.parse(id) % otherImages.length]);
    }

    return urlToFile(id);
  }

  @override
  Future<File> fetchPartnerEncryptedPrivatePicture({
    required String username,
    required String id,
  }) {
    return fetchPartnerPublicPicture(username: username, id: id);
  }

  // Utils

  final images = [
    'https://purepng.com/public/uploads/large/purepng.com-tom-and-jerry-happytom-and-jerrytomjerryanimated-seriesin-1940characters-1701528659229lrdcn.png',
    'https://wallpapercave.com/wp/wp1841509.jpg',
    'https://purepng.com/public/uploads/large/purepng.com-tom-and-jerry-happytom-and-jerrytomjerryanimated-seriesin-1940characters-1701528659229lrdcn.png',
    'https://1.bp.blogspot.com/-4AhtysiqNb4/UdFpEgcI8UI/AAAAAAAAMcg/-42l-nNXVBs/s1600/tom_and_jerry.jpg',
    'https://www.fortressofsolitude.co.za/wp-content/uploads/2018/10/Tom-And-Jerry.jpg',
    'https://wallpapercave.com/wp/wp1841509.jpg',
    'https://br.web.img3.acsta.net/pictures/14/08/18/09/28/523324.jpg',
    'https://1.bp.blogspot.com/-4AhtysiqNb4/UdFpEgcI8UI/AAAAAAAAMcg/-42l-nNXVBs/s1600/tom_and_jerry.jpg',
    'https://br.web.img3.acsta.net/pictures/14/08/18/09/28/523324.jpg',
    'https://www.fortressofsolitude.co.za/wp-content/uploads/2018/10/Tom-And-Jerry.jpg',
  ];

  final otherImages = [
    'https://www.pngall.com/wp-content/uploads/5/Second-Place-PNG-Picture.png',
    'https://www.guardian-angel-reading.com/uploads/2020/07/PA_SEO_637_Opening-your-Third-Eye.jpg',
    'https://ebooksz.net/wp-content/uploads/2020/04/A-Visual-Introduction-to-the-Fourth-Dimension-Rectangular-4D-Geometry-1.jpg',
  ];

  List<UserDTO> _createMockUsers(
    int numberOfPartner,
    List<String> alreadyFetchedUsers,
  ) {
    late List<UserDTO> mockPartners;
    if (counter == 1) {
      mockPartners = [..._mockPartners]..removeWhere(
          (element) => alreadyFetchedUsers.contains(element.username),
        );
    } else {
      mockPartners = [];
      counter++;
    }

    for (var i = mockPartners.length; i < numberOfPartner; i++) {
      mockPartners.add(
        UserDTO(
          username: 'mock$i${DateTime.now().microsecondsSinceEpoch}',
          publicInfo: PublicInfoDTO(
            sex: 0,
            searching: const RangeValuesDTO(0, 0),
            textInfo: const {'name': 'Mock', 'surname': 'Partner'},
            dateInfo: {'birthdate': DateTime.fromMicrosecondsSinceEpoch(1)},
            boolInfo: const {'mock': true},
            interests: const <String>[
              'Bnana',
              'Patate',
              'Paperelle',
              'Abracadabra',
              'ThisIsAVeryLongAndBoringInterest'
            ],
            bio: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris 
nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in 
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in 
culpa qui officia deserunt mollit anim id est laborum.''',
            pictures: const ['0', '1', '2', '3'],
          ),
          privateInfo: const PrivateInfoDTO(),
          publicKey: <String, dynamic>{
            'modulus':
                'x9OK0Yk5E+aOLjtpuoXwS8omhPuOZTgDAeWf2taMYpnQRhcO3jiEqGBLsBAX+sYmpENV2DF22fRNNH40yRa9voUIPFsU4q4BEI1KqF3OadBZuX8Obc4dPKkaFWkYepABon/z6isPussjMYH3uyolKKBH5HPB+Y4EXKqAnW54dGc=',
            'exponent': 'AQAB'
          },
        ),
      );
    }
    return mockPartners;
  }

  Future<File> urlToFile(String imageUrl) async {
    if (cacheImage.containsKey(imageUrl)) {
      return File(cacheImage[imageUrl]!);
    }
// generate random number.
    final rng = Random();
// get temporary path from temporary directory.
    final tempPath = _directoryToStoreFiles;
// create a new file in temporary path with random file name.
    final file = File('$tempPath${rng.nextInt(10000)}.png');
// call http.get method and pass imageUrl into it to get response.
    final response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    cacheImage.putIfAbsent(imageUrl, () => file.path);
    return file;
  }

  @override
  Future<Map<String, dynamic>> fetchPublicKey({
    required String username,
  }) async {
    if (username == 'mark88') {
      return <String, dynamic>{
        'modulus':
            'l+RSyTYFzNxzyBro9je1saTK1rDhCdinIYnu7ljtLM98RuTabhY8k/vrnc/HHUjRS3HqbvmgkiR5PQBmS6yhJ/ax+7akAnhvzIk2RYjoA18Cvy5qGqP8FkgQ9hcUnX2mSr1cZ+Muauij7HQE9dwX57kaxtSZPS7CEskm6oUxLBfSoQQ0R83PxKfsiE9VHQ2h4AijlOkkIk0EXo0cZaurEi0h7R0LxMNYRzM68pAKZ+tUl1ykTfFAjS2EI9HODti3+CQikuaWkBz+P3LvqpcwmFEKZ6gCvmN+QfQu/+0uUMPP+yEtslq42VbEIYGk1/Kg9+aTVQO4+THHpgcDRVb2Zw==',
        'exponent': 'AQAB'
      };
    }
    return <String, dynamic>{
      'modulus':
          'x9OK0Yk5E+aOLjtpuoXwS8omhPuOZTgDAeWf2taMYpnQRhcO3jiEqGBLsBAX+sYmpENV2DF22fRNNH40yRa9voUIPFsU4q4BEI1KqF3OadBZuX8Obc4dPKkaFWkYepABon/z6isPussjMYH3uyolKKBH5HPB+Y4EXKqAnW54dGc=',
      'exponent': 'AQAB'
    };
  }

  @override
  Future<UserDTO> fetchPartner({required String username}) async {
    return _mockPartners.firstWhere(
      (partner) => partner.username == username,
      orElse: () => UserDTO(
        username: username,
        publicInfo: PublicInfoDTO(
          sex: 0,
          searching: const RangeValuesDTO(0, 0),
          textInfo: const {'name': 'Mock', 'surname': 'Partner'},
          dateInfo: {'birthdate': DateTime.fromMicrosecondsSinceEpoch(1)},
          boolInfo: const {'mock': true},
          interests: const <String>[
            'Bnana',
            'Patate',
            'Paperelle',
            'Abracadabra',
            'ThisIsAVeryLongAndBoringInterest'
          ],
          bio: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris 
nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in 
reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in 
culpa qui officia deserunt mollit anim id est laborum.''',
          pictures: const ['0', '1', '2', '3'],
        ),
        privateInfo: const PrivateInfoDTO(),
        publicKey: <String, dynamic>{
          'modulus':
              'x9OK0Yk5E+aOLjtpuoXwS8omhPuOZTgDAeWf2taMYpnQRhcO3jiEqGBLsBAX+sYmpENV2DF22fRNNH40yRa9voUIPFsU4q4BEI1KqF3OadBZuX8Obc4dPKkaFWkYepABon/z6isPussjMYH3uyolKKBH5HPB+Y4EXKqAnW54dGc=',
          'exponent': 'AQAB'
        },
      ),
    );
  }
}
