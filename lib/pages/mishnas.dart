import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/seder.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/data/seders.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';
import 'package:daf_plus_plus/widgets/core/sectionHeader.dart';

class MishnasPage extends StatelessWidget {
  MishnasPage({@required this.preferredCalendar});
  final String preferredCalendar;

  List<Widget> _generateList() {
    String prevSederId;
    List<Widget> list = [];
    MasechetsData.THE_MASECHETS.values.forEach((MasechetModel masechet) {
      if (prevSederId != masechet.sederId) {
        list.add(
          SliverStickyHeader(
            sticky: false,
            header: SectionHeaderWidget(
              header: localizationUtil.translate("general", "seder") +
                  " " +
                  localizationUtil.translate(
                      "shas",
                      SedersData.THE_SEDERS
                          .firstWhere((SederModel seder) =>
                              seder.id == masechet.sederId)
                          .id),
            ),
          ),
        );
        prevSederId = masechet.sederId;
      }
      list.add(
        MasechetWidget(
          position: DafModel(masechetId: masechet.id),
          preferredCalendar: preferredCalendar,
          progressType: ProgressType.PROGRESS_MISHNA,
        ),
      );
    });
    return list;
  }

  Widget _bottomSpacer() {
    return SliverStickyHeader(
      header: Container(
        height: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [..._generateList(), _bottomSpacer()],
    );
  }
}
