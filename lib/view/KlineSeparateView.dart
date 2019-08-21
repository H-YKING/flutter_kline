import 'package:flutter/material.dart';
import 'package:candleline/bloc/KlineBloc.dart';
import 'package:candleline/common/BlocProvider.dart';
import 'package:candleline/model/KlineModel.dart';
import 'package:flutter/foundation.dart';

class KlineSeparateView extends StatelessWidget {
  KlineSeparateView({Key key, @required this.type});
  final int type;

  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = BlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
        stream: klineBloc.outCurrentKlineList,
        builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
          return CustomPaint(
              size: Size.infinite,
              painter: _SeparateViewPainter(
                type: type,
                data: tmpList,
                lineWidth: 0.5,
                rectWidth: klineBloc.rectWidth,
                max: klineBloc.priceMax,
                min: klineBloc.priceMin,
                maxVolume: klineBloc.volumeMax,
                lineColor: new Color.fromRGBO(255, 255, 255, 0.3),
              ));
        });
  }
}

class _SeparateViewPainter extends CustomPainter {
  _SeparateViewPainter(
      {Key key,
      @required this.data,
      @required this.max,
      @required this.min,
      @required this.maxVolume,
      @required this.rectWidth,
      this.lineWidth = 1.0,
      this.lineColor = Colors.grey,
      this.type});

  final List<Market> data;
  final double lineWidth;
  final Color lineColor;
  final double max;
  final double min;
  final double maxVolume;
  final double rectWidth;
  final int type;
  final double start = 30;

  @override
  void paint(Canvas canvas, Size size) {
    if (max == null || min == null) {
      return;
    }

    _drawGrid(canvas, size);

    drawPriceLine(canvas, size);
    drawVolumeLine(canvas, size);
  }

  drawText(Canvas canvas, Offset offset, String text) {
    TextPainter textPainter = new TextPainter(
        text: new TextSpan(
            text: text,
            style: new TextStyle(
                color: lineColor,
                fontSize: 10.0,
                fontWeight: FontWeight.normal)),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  void _drawGrid(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;

    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    //绘制横线
    double heightOffset = (height - start) / 5;
    double _reactWidth = (width ~/ 5).toDouble();

    //绘制横线
    canvas.drawLine(Offset(0, start), Offset(width, start), linePaint);
    for (var i = 1; i < 6; i++) {
      canvas.drawLine(Offset(0, heightOffset * i + start),
          Offset(width, heightOffset * i + start), linePaint);
    }
    //绘制竖线
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(Offset(i * _reactWidth, 0),
          Offset(i * _reactWidth, height), linePaint);
    }
  }

  drawPriceLine(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    double fontSizeHeight = 12;
    int row = 5;
    double begin = height - start;
    double heightOffset = begin / 5;
    double priceOffset = (max - min) / row;
    double origin = width - max.toStringAsPrecision(7).length * 6;

    //绘制最大的
    drawText(canvas, Offset(origin, start - fontSizeHeight),
        max.toStringAsPrecision(7));

    drawText(canvas, Offset(origin, start + heightOffset - 12),
        (min + priceOffset * 4).toStringAsPrecision(7));
    drawText(canvas, Offset(origin, start + heightOffset * 2 - 12),
        (min + priceOffset * 3).toStringAsPrecision(7));
    drawText(canvas, Offset(origin, start + heightOffset * 3 - 12),
        (min + priceOffset * 2).toStringAsPrecision(7));

    //绘制最小的
    drawText(canvas, Offset(origin, height - heightOffset - 12),
        min.toStringAsPrecision(7));
  }

  drawVolumeLine(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    double begin = height - start;
    double heightOffset = begin / 5;
    double origin = width - max.toStringAsPrecision(7).length * 6;
    drawText(canvas, Offset(origin, start + heightOffset * 4 + 5),
        maxVolume.toStringAsPrecision(7));
  }

  @override
  bool shouldRepaint(_SeparateViewPainter old) {
    return data != null;
  }
}
