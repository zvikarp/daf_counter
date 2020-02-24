import 'package:daf_counter/data/masechets.dart';
import 'package:daf_counter/data/seders.dart';
import 'package:daf_counter/models/masechet.dart';
import 'package:daf_counter/widgets/masechetCard.dart';
import 'package:daf_counter/widgets/sectionTitle.dart';
import 'package:daf_counter/widgets/seder.dart';
import 'package:flutter/material.dart';

class ShasWidget extends StatelessWidget {
  List<Widget> _generateList() {
    int prevSederId = -1;
    List<Widget> list = [];
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
      if (prevSederId != masechet.sederId) {
        list.add(SederWidget(
          seder: SedersData.THE_SEDERS[masechet.sederId],
        ));
        prevSederId = masechet.sederId;
      }
      list.add(
        MasechetCardWidget(
          masechet: masechet,
        ),
      );
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionTitleWidget(
          title: "כל השס",
        ),
        Expanded(
          child: CustomScrollView(
            slivers: _generateList(),
          ),
        ),
      ],
    );
  }
}
