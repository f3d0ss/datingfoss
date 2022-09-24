import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/partner_detail/bloc/partner_detail_bloc.dart';
import 'package:datingfoss/utils/range_values_extension.dart';
import 'package:datingfoss/widgets/bio_widget.dart';
import 'package:datingfoss/widgets/bool_info_row.dart';
import 'package:datingfoss/widgets/date_info_row.dart';
import 'package:datingfoss/widgets/interests_row.dart';
import 'package:datingfoss/widgets/location_widget.dart';
import 'package:datingfoss/widgets/privatizable_searching_slider.dart';
import 'package:datingfoss/widgets/privatizable_sex_slider.dart';
import 'package:datingfoss/widgets/text_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class PartnerDetailPage extends StatelessWidget {
  const PartnerDetailPage({
    required this.partnerUsername,
    List<String>? keys,
    super.key,
  }) : _keys = keys;

  final String partnerUsername;
  final List<String>? _keys;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.buildBloc<PartnerDetailBloc>(
        param1: partnerUsername,
        param2: _keys,
      )..add(FetchPartnerRequested(_keys)),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, appState) {
          return BlocBuilder<PartnerDetailBloc, PartnerDetailState>(
            builder: (context, state) {
              final textInfo = state.partner.textInfo;
              final dateInfo = state.partner.dateInfo;
              final boolInfo = state.partner.boolInfo;
              final location = state.partner.location;
              final sex = state.partner.sex;
              final searching = state.partner.searching;
              final interests = state.partner.commonableInterest(
                appState.user.interests.map((e) => e.data).toList(),
              );
              final privateBio = state.partner.privateInfo?.bio;
              double? distance;
              if (state.partner.publicInfo.location != null) {
                distance = appState.user
                    .getDistance(from: state.partner.publicInfo.location!);
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 400,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(state.partner.name ?? state.partner.username),
                      background: Flex(
                        direction: Axis.vertical,
                        children: [
                          Expanded(
                            flex: 7,
                            child: PartnerImages(
                              pictures: state.pictures,
                            ),
                          ),
                          const Expanded(
                            child: Text(''),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  NameAndDateRow(partner: state.partner),
                                  Text(
                                    distance != null
                                        ? '${distance.toStringAsFixed(2)} Km'
                                        : 'No distance',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: textInfo
                                    .map<String, Widget>(
                                      (key, value) => MapEntry(
                                        key,
                                        TextInfoRow(id: key, data: value),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ),
                              const Divider(),
                              Column(
                                children: boolInfo
                                    .map<String, Widget>(
                                      (key, value) => MapEntry(
                                        key,
                                        BoolInfoRow(id: key, data: value),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ),
                              const Divider(),
                              Column(
                                children: dateInfo
                                    .map<String, Widget>(
                                      (key, value) => MapEntry(
                                        key,
                                        DateInfoRow(id: key, data: value),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ),
                              const Divider(),
                              IterestsRow(interests: interests),
                              const Divider(),
                              BioWidget(
                                bio: state.partner.publicInfo.bio,
                                private: false,
                              ),
                              const Divider(),
                              if (privateBio != null)
                                Column(
                                  children: [
                                    BioWidget(
                                      bio: state.partner.publicInfo.bio,
                                      private: false,
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              if (searching != null)
                                Column(
                                  children: [
                                    const Text(
                                      'Searching',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    PrivatizableSearchingSlider(
                                      initialValue: PrivateData(
                                        searching.data.materialRangeValues,
                                        private: searching.private,
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              if (sex != null)
                                Column(
                                  children: [
                                    const Text(
                                      'Sex',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    PrivatizableSexSlider(
                                      initialValue: PrivateData(
                                        sex.data,
                                        private: sex.private,
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              if (location != null)
                                Column(
                                  children: [
                                    const Text(
                                      'Location',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    LocationWidget(location: location),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class NameAndDateRow extends StatelessWidget {
  const NameAndDateRow({
    super.key,
    required Partner partner,
  }) : _partner = partner;

  final Partner _partner;

  @override
  Widget build(BuildContext context) {
    const nameTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 14,
        ),
      ],
    );
    const ageTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 5,
        ),
      ],
    );
    var displayName = '';
    if (_partner.name != null && _partner.name!.isNotEmpty) {
      displayName = '${_partner.name!} ${_partner.surname ?? ''}';
    } else {
      displayName = _partner.username;
    }
    return Row(
      children: [
        Text(
          displayName,
          style: nameTextStyle,
        ),
        Text(
          _partner.age?.toString() ?? '--',
          style: ageTextStyle,
        ),
      ],
    );
  }
}

class PartnerImages extends StatelessWidget {
  const PartnerImages({
    super.key,
    required Map<String, File> pictures,
  }) : _pictures = pictures;

  final Map<String, File> _pictures;
  static const Image noImageBackground = Image(
    image: AssetImage('assets/images/noImageBackground.png'),
    fit: BoxFit.cover,
  );

  @override
  Widget build(BuildContext context) {
    final carouselController = CarouselController();
    if (_pictures.isEmpty) {
      return noImageBackground;
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1,
      ),
      carouselController: carouselController,
      items: _pictures
          .map<String, Widget>(
            (picId, pic) {
              return MapEntry(
                picId,
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Hero(
                        tag: picId,
                        child: Image.file(
                          key: Key(picId),
                          _pictures[picId]!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: carouselController.previousPage,
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: carouselController.nextPage,
                              child: Container(
                                width: double.infinity,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
          .values
          .toList(),
    );
  }
}
