import 'package:common/constants/constants_enum.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../constants/constants_colors.dart';
import '../../../constants/constants_value.dart';

class CountrySelectBottomSheet extends StatefulWidget {
  final Country country;
  const CountrySelectBottomSheet({Key? key, required this.country})
      : super(key: key);

  @override
  State<CountrySelectBottomSheet> createState() =>
      _CountrySelectBottomSheetState();
}

class _CountrySelectBottomSheetState extends State<CountrySelectBottomSheet> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    _initialIndex =
        Country.values.indexWhere((element) => element == widget.country);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: Container(
        height: kBottomSheetHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              width: double.infinity,
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: kFontGray100Color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: Country.values.length,
                initialScrollIndex: _initialIndex,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, Country.values[index]),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: kWhiteColor,
                      height: 50,
                      child: Text(
                        '${Country.values[index].name}(+${Country.values[index].code})',
                        style: TextStyle(
                          color: Country.values[index] == widget.country
                              ? kMainColor
                              : kFontGray600Color,
                          fontWeight: Country.values[index] == widget.country
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
