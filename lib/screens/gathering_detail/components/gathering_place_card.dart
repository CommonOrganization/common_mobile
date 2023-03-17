import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_value.dart';
import '../../../models/gathering_place/gathering_place.dart';
import '../../../services/http_service.dart';

class GatheringPlaceCard extends StatelessWidget {
  final Map place;
  const GatheringPlaceCard({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GatheringPlace gatheringPlace =
        GatheringPlace.fromJson(place as Map<String, dynamic>);
    String placeDetail =
        '${gatheringPlace.city} ${gatheringPlace.county} ${gatheringPlace.detail}'
            .replaceAll('전체 ', '');
    return GestureDetector(
      onTap: () async {
        Uri uri = Uri.parse('$kNaverMapSearchBaseUrl/$placeDetail');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        color: kWhiteColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/icons/svg/location_gray.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placeDetail,
                          style: TextStyle(
                            fontSize: 14,
                            color: kFontGray600Color,
                            height: 18 / 14,
                          ),
                        ),
                        FutureBuilder(
                          future:
                              HttpService.searchPlaceWithKeyword(placeDetail),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kFontGray400Color,
                                  height: 16 / 12,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    'assets/icons/svg/arrow_more_22px.svg',
                    width: 20,
                    height: 20,
                    fit: BoxFit.scaleDown,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
