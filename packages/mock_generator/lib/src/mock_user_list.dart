import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';
import 'package:path/path.dart';

class MockUserList {
  MockUserList({required String basePath})
      : _assetsPath = '${basePath}assets/images/',
        _tmpPath = '${basePath}tmp/';

  final String _assetsPath;
  final String _tmpPath;

  LocalSignupUser getLoginUser() => addPictures(
        LocalSignupUser(
          username: 'shaki',
          password: 'shaki000',
          sex: const PrivateData(0),
          searching: const PrivateData(RangeValues(0, 1)),
          textInfo: {
            'name': const PrivateData('Shakira'),
            'surname': const PrivateData('Ripoll', private: true),
            'occupation': const PrivateData('Singer'),
            'secret passion': const PrivateData('Flutter', private: true),
          },
          dateInfo: {
            'birthdate': PrivateData(DateTime(1977, 2, 2)),
          },
          boolInfo: const {
            'fake': PrivateData(true),
            'evil': PrivateData(true, private: true),
            'children': PrivateData(true, private: true),
          },
          interests: [
            'Songs',
            'Latino',
            'Tennis',
            'Photography',
          ],
          privateInsterests: [
            'Drink',
            'Beer',
            'Shopping',
          ],
          bio: '''
I'm a Colombian singer. Born and raised in Barranquilla, I have been referred to as the "Queen of Latin Music" and I'm noted for my musical versatility.''',
          privateBio: '''
I made my recording debut with Sony Music Colombia at the age of 13. Following the commercial failure of my first two albums, Magia (1991) and Peligro (1993), I rose to prominence in Hispanic countries with my next albums, Pies Descalzos (1995) and Dónde Están los Ladrones? (1998)''',
          location: PrivateData(LatLng(40.7125, -74.0049)),
        ),
      );
//

  List<LocalSignupUser> getList() => [
        LocalSignupUser(
          username: 'mark88',
          password: 'mark8888',
          sex: const PrivateData(0),
          searching: const PrivateData(RangeValues(0, 0.5)),
          textInfo: {
            'name': const PrivateData('Mark'),
            'surname': const PrivateData('Zucca'),
            'occupation': const PrivateData('Monopolis expert'),
            'secret passion':
                const PrivateData('Eat Mc Nuggets', private: true),
          },
          dateInfo: {
            'first line of code':
                PrivateData(DateTime.fromMicrosecondsSinceEpoch(1)),
          },
          boolInfo: const {
            'fake': PrivateData(true, private: true),
            'evil': PrivateData(true),
          },
          interests: [
            'Computers',
            'Data of everyone',
            'Paperelle',
            'Abracadabra',
            'Surf'
          ],
          privateInsterests: [
            'Art',
            'Video games',
            'Music',
          ],
          bio: '''
I'm an American media magnate, internet entrepreneur, and philanthropist. I'm known for co-founding the social media website Facebook and its parent company Meta Platforms.''',
          privateBio: '''
I attended Harvard University, where I launched Facebook in February 2004 with my roommates Eduardo Saverin, Andrew McCollum, Dustin Moskovitz, and Chris Hughes. Originally launched to select college campuses, the site expanded rapidly and eventually beyond colleges, reaching one billion users by 2012. I took the company public in May 2012 with majority shares. ''',
          location: PrivateData(LatLng(40.7125, -74.0049), private: true),
        ),
        LocalSignupUser(
          username: 'miley',
          password: 'miley000',
          sex: const PrivateData(0.1),
          searching: const PrivateData(RangeValues(0, 1)),
          textInfo: {
            'name': const PrivateData('Miley'),
            'surname': const PrivateData('Cyrus'),
            'real name': const PrivateData('Destiny Hope'),
            'occupation': const PrivateData('Singer'),
            'secret passion': const PrivateData('Flutter', private: true),
          },
          dateInfo: {
            'birthdate': PrivateData(DateTime(1992, 11, 23)),
            'married': PrivateData(DateTime(2018, 12, 23), private: true),
          },
          boolInfo: const {
            'fake': PrivateData(true),
            'evil': PrivateData(false, private: true),
            'children': PrivateData(false),
          },
          interests: [
            'Songs',
            'Latino',
            'Tennis',
            'Photography',
          ],
          privateInsterests: [
            'Drink',
            'Tatoo',
            'Art',
          ],
          bio: '''
I'm an American singer, songwriter, and actress. My music incorporates elements of varied styles and genres, including pop, country pop, hip hop, experimental, and rock.''',
          privateBio: '''
I'm the daughter of country music singer Billy Ray Cyrus, emerged as a teen idol while portraying the title character of the Disney Channel television series Hannah Montana (2006–2011)''',
          location: PrivateData(LatLng(40.7125, -74.0049)),
        ),
        LocalSignupUser(
          username: 'eddy97',
          password: 'eddy97',
          sex: const PrivateData(1),
          searching: const PrivateData(RangeValues(0, 1)),
          textInfo: {
            'name': const PrivateData('Edward'),
            'surname': const PrivateData('Showden'),
            'occupation': const PrivateData('Whistle blower'),
            'secret ass size': const PrivateData('20 mp', private: true),
          },
          dateInfo: {
            'birthdate': PrivateData(DateTime.fromMicrosecondsSinceEpoch(1)),
          },
          boolInfo: const {
            'fake': PrivateData(true),
            'evil': PrivateData(false),
          },
          interests: ['Computers', 'Privacy', 'Family', 'Books'],
          privateInsterests: ['Video games', 'Travel', 'Karaoke'],
          bio: '''
American former computer intelligence consultant who leaked highly classified information from the National Security Agency (NSA) in 2013, when I was an employee and subcontractor.''',
          privateBio: '''
In 2013, I was hired by an NSA contractor, Booz Allen Hamilton, after previous employment with Dell and the CIA. I gradually became disillusioned with the programs with which I was involved, and I tried to raise my ethical concerns through internal channels but was ignored. On May 20, 2013, I flew to Hong Kong after leaving my job at an NSA facility in Hawaii, and in early June I revealed thousands of classified NSA documents to journalists Glenn Greenwald, Laura Poitras, Barton Gellman, and Ewen MacAskill.''',
          location: PrivateData(LatLng(12, 12)),
        ),
        LocalSignupUser(
          username: 'monty',
          password: 'monty000',
          sex: const PrivateData(1),
          searching: const PrivateData(RangeValues(0, 1)),
          textInfo: {
            'name': const PrivateData('Marco'),
            'surname': const PrivateData('Montemagno'),
            'occupation': const PrivateData('Imprenditore di me stesso'),
            'real occupation': const PrivateData('Influencer', private: true),
          },
          dateInfo: {
            'first talk': PrivateData(DateTime(1985, 1, 14)),
          },
          boolInfo: const {
            'like dogs': PrivateData(false),
            'like cats': PrivateData(false, private: true),
          },
          interests: ['Hiking', 'Beer', 'Pizza', 'Family', 'Laugh'],
          privateInsterests: ['Music', 'Work', 'Adventure', 'Tatoo'],
          bio: '''
I wrote 3 books (all bestsellers), interviewed incredible people (from Matthew McConaughey to Moby, Jeff Bezos to Tony Robbins and practically all the great Italian celebrities). I have launched various startups and raised millions in crowdfunding.''',
          privateBio: '''
Monty has 20 years experience in tech and he has created a 3 million strong community on social media.''',
          location: PrivateData(LatLng(12, 12)),
        ),
        LocalSignupUser(
          username: 'ferra',
          password: 'ferra000',
          sex: const PrivateData(0),
          searching: const PrivateData(RangeValues(0, 1)),
          textInfo: {
            'name': const PrivateData('Chiara'),
            'surname': const PrivateData('Ferragni'),
            'occupation': const PrivateData('Blogger'),
            'secret passion': const PrivateData('Rapper', private: true),
          },
          dateInfo: {
            // ignore: avoid_redundant_argument_values
            'married': PrivateData(DateTime(218, 09, 01)),
            'first son': PrivateData(DateTime(2018, 03, 19), private: true),
            'birthdate': PrivateData(DateTime(1987, 04, 11), private: true),
          },
          boolInfo: const {
            'fake': PrivateData(true),
            'evil': PrivateData(false, private: true),
            'children': PrivateData(true),
          },
          interests: ['Songs', 'Art', 'Tennis', 'Photography'],
          privateInsterests: ['Drink', 'Tatoo', 'Karaoke'],
          bio: '''
I'm an Italian blogger, businesswoman, fashion designer and model who has collaborated with fashion and beauty brands through my blog The Blonde Salad. In September 2017, I was ranked first on the Forbes "Top Fashion Influencers" list.''',
          privateBio: '''
I was born in Cremona in 1987. At the age of 16 was chosen by the Beatrice agency in Milan, Italy. I modeled for the agency for a couple of years and then stopped: due to "other goals to reach in my life". I started my fashion blog "The Blonde Salad" in October 2009, with a former boyfriend, Riccardo Pozzoli.''',
          location: PrivateData(LatLng(40.7125, -74.0049)),
        ),
        LocalSignupUser(
          username: 'billy',
          password: 'billy000',
          sex: const PrivateData(1),
          searching: const PrivateData(RangeValues(0, 1)),
          textInfo: {
            'name': const PrivateData('Bill'),
            'surname': const PrivateData('Cancello'),
            'occupation': const PrivateData('Monopolist'),
            'motto': const PrivateData(
              "Security? You don't need security. I'M watching you.",
              private: true,
            ),
          },
          dateInfo: {
            'forced IE on PCs': PrivateData(DateTime(1995, 08, 16)),
            'birthdate': PrivateData(DateTime(1955, 10, 31)),
          },
          boolInfo: const {
            'greedy': PrivateData(true),
            'like cats': PrivateData(false, private: true),
          },
          interests: ['Work', 'Pizza', 'Family', 'Money'],
          privateInsterests: ['Music', 'Drink', 'Tatoo'],
          bio: r'''
I'm an obsolete, closed-source x86 microprocessor with 640K of L1 cache which runs MS-DOS. I'm extremely rich and one of the biggest nerds ever; I'm such a nerd that I started my own personal computer company, Microsoft, back in 1975 of which I was the "CEO" (or "head nerd") until 2000, and I'm also the company's largest shareholder with 95% of the stock. As of 2022, I'm noted as being the fourth-richest man alive, with an estimated net worth of $∞.''', // That's expected to diminish once I terminates my marriage to Melinda without a full system reboot.''',
          privateBio: r'''
Aside from being very rich and nerdy, I'm also a philanthropist. Over the past two decades, I have donated over $77.3 billion (Exactly 0.008% of my total moneys.) to various organizations, including the League of Nerdlingers and the United Negro College Fund. In 2005, People magazine named me "Unsexiest Nerd Alive", and later that same year, I was voted #9 on Rolling Stone's list of the 50 Greatest Inventors''', // beating out the guy who invented the doorbell and the guy who invented the machine that puts those "Dole" stickers on bananas.''',
          location: PrivateData(LatLng(12, 13)),
        ),
      ].map(addPictures).toList();

  LocalSignupUser addPictures(LocalSignupUser user) {
    final publicPictures = Directory('$_assetsPath${user.username!}/public')
        .listSync()
        .map(
          (entry) =>
              File(entry.path).copySync('$_tmpPath${basename(entry.path)}'),
        )
        .toList();
    final privatePictures = Directory('$_assetsPath${user.username!}/private')
        .listSync()
        .map(
          (entry) =>
              File(entry.path).copySync('$_tmpPath${basename(entry.path)}'),
        )
        .toList();
    return user.copyWith(
      pictures: publicPictures,
      privatePictures: privatePictures,
    );
  }
}
