import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/shared/daf.dart';

class MasechetChildrenWidget extends StatefulWidget {
  MasechetChildrenWidget(
      {@required this.masechet,
      this.lastDafIndex = -1,
      this.onProgressChange = _dontChangeProgress,
      this.hasPadding = false});

  static dynamic _dontChangeProgress(List<int> progress) {}

  final MasechetModel masechet;
  final int lastDafIndex;
  final Function(List<int>) onProgressChange;
  final bool hasPadding;

  @override
  _MasechetChildrenWidgetState createState() => _MasechetChildrenWidgetState();
}

class _MasechetChildrenWidgetState extends State<MasechetChildrenWidget> {
  List<int> _progress = [];
  List<DateTime> _dates = [];
  Stream<String> _progressUpdates;

  void _onClickDaf(int dafIndex, int count) {
    _updateDafCount(dafIndex, count);
    _updateLastDaf(dafIndex);
  }

  void _updateLastDaf(int dafIndex) {
    DafLocationModel dafLocation =
        DafLocationModel(masechetId: widget.masechet.id, dafIndex: dafIndex);
    hiveService.settings.setLastDaf(dafLocation);
  }

  void _updateDafCount(int dafIndex, int count) {
    List<int> progress = _progress;
    progress[dafIndex] = count;
    String encodedProgress = masechetConverterUtil.encode(progress);
    progressAction.update(widget.masechet.id, encodedProgress);
  }

  List<int> _generateNewProgress() => List.filled(widget.masechet.numOfDafs, 0);

  List<int> _getMasechetProgress() {
    String encodedProgress =
        hiveService.progress.getMasechetProgress(widget.masechet.id);
    return encodedProgress != null
        ? masechetConverterUtil.decode(encodedProgress)
        : _generateNewProgress();
  }

  void _listenToUpdates() {
    _progressUpdates =
        hiveService.progress.listenToProgress(widget.masechet.id);
    _progressUpdates.listen((String updatedProgress) {
      List<int> progress = masechetConverterUtil.decode(updatedProgress);
      if (progress == null) progress = _generateNewProgress();
      setState(() => _progress = progress);
      widget.onProgressChange(_progress);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    List<int> progress = _getMasechetProgress();
    List<DateTime> dates =
        dafsDatesStore.getAllMasechetDates(widget.masechet.id);
    setState(() {
      _progress = progress;
      _dates = dates;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onProgressChange(_progress);
    });
    _listenToUpdates();
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.masechet.numOfDafs;
    count = widget.hasPadding ? count + 1 : count;
    return Scrollbar(
      child: ScrollablePositionedList.builder(
        initialScrollIndex: widget.lastDafIndex != -1 ? widget.lastDafIndex : 0,
        itemBuilder: (context, dafIndex) {
          if (widget.hasPadding && count == dafIndex + 1)
            return Container(height: 100);
          return DafWidget(
            dafNumber: dafIndex,
            dafCount: _progress[dafIndex],
            dafDate: _dates != null &&
                    _dates.length > dafIndex &&
                    _dates[dafIndex] != null
                ? _dates[dafIndex]
                : "",
            onChangeCount: (int count) => _onClickDaf(dafIndex, count),
          );
        },
        itemCount: count,
      ),
    );
  }
}
