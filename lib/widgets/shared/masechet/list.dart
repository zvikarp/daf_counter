import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/daf.dart';

class MasechetListWidget extends StatefulWidget {
  MasechetListWidget({
    @required this.masechet,
    @required this.progress,
    @required this.preferredCalendar,
    this.lastDafIndex = -1,
    this.onProgressChange = _dontChangeProgress,
    this.hasPadding = false,
    this.dafYomi = -1,
  });

  static dynamic _dontChangeProgress(LearnType learnType, int daf) {}

  final MasechetModel masechet;
  final ProgressModel progress;
  final int lastDafIndex;
  final Function(LearnType, int) onProgressChange;
  final bool hasPadding;
  final String preferredCalendar;
  final int dafYomi;

  @override
  _MasechetListWidgetState createState() => _MasechetListWidgetState();
}

class _MasechetListWidgetState extends State<MasechetListWidget> {
  List<DateTime> _dates = [];

  void _onClickDaf(int daf, LearnType learnType) {
    hiveService.settings
        .setLastDaf(DafModel(masechetId: widget.masechet.id, number: daf));
    widget.onProgressChange(learnType, daf);
  }

  @override
  void initState() {
    super.initState();
    List<DateTime> dates =
        dafsDatesStore.getAllMasechetDates(widget.masechet.id);
    setState(() => _dates = dates);
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.progress?.data?.length ?? 0;
    count = widget.hasPadding ? count + 1 : count;
    return Scrollbar(
      child: ScrollablePositionedList.builder(
        initialScrollIndex: widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
        itemCount: count,
        itemBuilder: (context, dafIndex) {
          if (widget.hasPadding && count == dafIndex + 1)
            return Container(height: 100);
          return DafWidget(
            dafNumber: dafIndex,
            dafCount: widget.progress?.data[dafIndex] ?? 0,
            dafDate: _dates != null &&
                    _dates.length > dafIndex &&
                    _dates[dafIndex] != null
                ? _dates[dafIndex]
                : "",
            onChangeCount: (learnType) => _onClickDaf(dafIndex, learnType),
            preferredCalendar: widget.preferredCalendar,
            isDafYomi: widget.dafYomi == dafIndex,
          );
        },
      ),
    );
  }
}
