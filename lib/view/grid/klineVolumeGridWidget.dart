/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 17:57:47
 * @LastEditTime: 2019-08-20 09:35:58
 */
import 'package:candleline/bloc/KlineBloc.1.dart';
import 'package:candleline/bloc/klineBlocProvider.dart';
import 'package:candleline/model/KlineModel.1.dart';
import 'package:candleline/model/klineConstrants.dart';
import 'package:flutter/material.dart';

class KlineVolumeGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);

    return StreamBuilder(
      stream: bloc.currentKlineListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
        return CustomPaint(
          size: Size.infinite,
          painter: _VolumeGridPainter(bloc.volumeMax),
        );
      },
    );
  }
}

class _VolumeGridPainter extends CustomPainter {
  final double maxVolume;
  _VolumeGridPainter(
    this.maxVolume,
  );
  final Color lineColor = kGridLineColor;
  final double lineWidth = kGridLineWidth;
  final double columnTopMargin = kColumnTopMargin;
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    // 绘制横线
    canvas.drawLine(Offset(0, columnTopMargin), Offset(width, columnTopMargin), linePaint);
    canvas.drawLine(Offset(0, height), Offset(width, height), linePaint);
    // 绘制竖线
    double widthOffset = (width ~/ kGridColumCount).toDouble();
    for (int i = 1; i < kGridColumCount; i++) {
      canvas.drawLine(Offset(i * widthOffset, columnTopMargin),
          Offset(i * widthOffset, height), linePaint);
    }
    if (maxVolume == null) {
      return;
    }
    // 绘制当前最大值
    double orginX =
        width - maxVolume.toStringAsPrecision(kGridPricePrecision).length * 6;
    _drawText(canvas, Offset(orginX, columnTopMargin),
        maxVolume.toStringAsPrecision(kGridPricePrecision));
  }

  _drawText(Canvas canvas, Offset offset, String text) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: kGridTextColor,
            fontSize: kGridPriceFontSize,
            fontWeight: FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return maxVolume != null;
  }
}