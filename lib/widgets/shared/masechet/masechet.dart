import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/list.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/title.dart';

class MasechetWidget extends StatefulWidget {
  MasechetWidget({
    @required this.position,
    @required this.preferredCalendar,
    @required this.progressType,
    this.inList = true,
    this.dafYomi = -1,
  });

  final DafModel position;
  final String preferredCalendar;
  final ProgressType progressType;
  final bool inList;
  final int dafYomi;

  @override
  _MasechetWidgetState createState() => _MasechetWidgetState();
}

class _MasechetWidgetState extends State<MasechetWidget> {
  bool _isExpanded = false;

  void _onChangeExpandedState(bool state) {
    setState(() => _isExpanded = state);
  }

  void _onProgressChange(LearnType learnType, int daf) {
    progressAction.update(
        widget.position.masechetId, learnType, widget.progressType, daf);
  }

  Widget _masechetTitle(MasechetModel masechet, ProgressModel progress) {
    return MasechetTitleWidget(
      masechet: masechet,
      progress: progress,
      inList: widget.inList,
      isExpanded: _isExpanded,
      onChangeExpanded: _onChangeExpandedState,
    );
  }

  SliverList _inListMasechetList(
      MasechetModel masechet, ProgressModel progress) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, _) => Container(
          height:
              widget.inList ? Consts.MASECHET_LIST_HEIGHT : double.maxFinite,
          child: MasechetListWidget(
            masechet: masechet,
            progress: progress,
            onProgressChange: _onProgressChange,
            lastPositionIndex: widget.position.number,
            preferredCalendar: widget.preferredCalendar,
          ),
        ),
        childCount: _isExpanded ? 1 : 0,
      ),
    );
  }

  Widget _masechetList(
      MasechetModel masechet, ProgressModel progress, int dafYomi) {
    return Expanded(
      child: MasechetListWidget(
          masechet: masechet,
          progress: progress,
          onProgressChange: _onProgressChange,
          lastPositionIndex: widget.position.number,
          hasPadding: true,
          preferredCalendar: widget.preferredCalendar,
          dafYomi: dafYomi),
    );
  }

  @override
  Widget build(BuildContext context) {
    BuildContext progressContext = progressAction.getProgressContext();
    return Observer(builder: (context) {
      ProgressStore progressStore = Provider.of<ProgressStore>(progressContext);
      ProgressModel progress = progressStore.getProgress(
          widget.position.masechetId, widget.progressType);
      MasechetModel masechet =
          MasechetsData.THE_MASECHETS[widget.position.masechetId];
      if (progress == null)
        progress = ProgressModel.empty(
            widget.progressType == ProgressType.PROGRESS_TB
                ? masechet.numOfDafsTB
                : masechet.numOfPerakim,
            widget.progressType);
      if (widget.inList) {
        return SliverStickyHeader(
          header: _masechetTitle(masechet, progress),
          sliver: _inListMasechetList(masechet, progress),
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _masechetTitle(masechet, progress),
            _masechetList(masechet, progress, widget.dafYomi),
          ],
        );
      }
    });
  }
}
