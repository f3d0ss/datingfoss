import 'package:flutter/material.dart';

extension IconsExtension on Icons {
  static IconData selectIconFromInterest(String interest) {
    switch (interest.toLowerCase()) {
      case 'photography':
        return Icons.camera_alt_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'karaoke':
        return Icons.mic_none_outlined;
      case 'basketball':
        return Icons.sports_basketball_outlined;
      case 'tennis':
        return Icons.sports_tennis_outlined;
      case 'drink':
        return Icons.wine_bar_outlined;
      case 'travel':
        return Icons.travel_explore_outlined;
      case 'art':
        return Icons.color_lens_outlined;
      case 'work':
        return Icons.work_outline;
      case 'adventure':
        return Icons.all_inclusive_rounded;
      case 'tatoo':
        return Icons.tonality_outlined;
      case 'books':
        return Icons.book_outlined;
      case 'movies':
        return Icons.movie_outlined;
      case 'sports':
        return Icons.sports_handball_outlined;
      case 'hiking':
        return Icons.hiking_outlined;
      case 'beer':
        return Icons.local_drink_outlined;
      case 'computers':
      case 'programming':
        return Icons.computer_outlined;
      case 'data of everyone':
        return Icons.privacy_tip_outlined;
      case 'surf':
        return Icons.surfing_outlined;
      case 'songs':
      case 'music':
        return Icons.music_note_outlined;
      case 'weed':
        return Icons.grass_outlined;
      case 'pizza':
        return Icons.local_pizza_outlined;
      case 'family':
        return Icons.family_restroom_outlined;
      case 'laugh':
        return Icons.emoji_emotions_outlined;
      case 'video games':
        return Icons.videogame_asset_outlined;
      case 'money':
        return Icons.money;
      default:
        return Icons.interests;
    }
  }
}
