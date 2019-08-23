import 'package:candleline/bloc/KlineBloc.1.dart';
import 'package:candleline/bloc/klineBlocProvider.dart';
import 'package:candleline/model/KlineModel.1.dart';
import 'package:candleline/model/klineConstrants.dart';
import 'package:candleline/util/date_util.dart';
import 'package:candleline/util/utils.dart';
import 'package:flutter/material.dart';

class KlineDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);

    return StreamBuilder(
      stream: bloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        return CustomPaint(
          size: Size(bloc.screenWidth, bloc.screenWidth / kVolumeAspectRatio),
          painter: _KlineDatePainter(snapshot.data, bloc.candlestickWidth),
        );
      },
    );
  }
}

class _KlineDatePainter extends CustomPainter {
  final List<Market> listData;

  /// 柱状体宽度
  final double columnarWidth;

  /// 柱状体之间间隙 = 烛台间空隙
  final double columnarGap = kColumnarGap;

  _KlineDatePainter(
    this.listData,
    this.columnarWidth,
  );

  final double lineWidth = kGridLineWidth;
  final Color lineColor = kGridLineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (listData == null) {
      return;
    }
    double height = size.height - kTopMargin;
    double width = size.width;
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

    // 画竖线
    double widthOffset = (width ~/ kGridColumCount).toDouble();
    double oneGridWidth = columnarWidth + columnarGap;
    int dataLen = listData.length;
    int gridItemLen = (widthOffset ~/ oneGridWidth).toInt();
    int totalDateNum = (dataLen ~/ gridItemLen).toInt();

    for (int i = 0; i <= totalDateNum; i++) {
      int _index = i * gridItemLen;
      Market market = listData[_index];

      final time = Utils.readTimestamp(market.id);
      final timeFormat = DateUtil.formatDateStr(time, format: "MM-dd HH:mm");

      _drawText(canvas, Offset(i * widthOffset, 5), timeFormat);
    }
  }

  _drawText(Canvas canvas, Offset offset, String text) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: kGridTextColor,
            fontSize: 8,
            fontWeight: FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    Offset of = Offset(offset.dx - textPainter.width * 0.5, 1);
    textPainter.paint(canvas, of);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // return max != null && min != null;
    return true;
  }
}
