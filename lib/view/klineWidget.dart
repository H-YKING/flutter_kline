/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-18 13:54:54
 * @LastEditTime: 2019-09-02 15:35:45
 */
import 'package:candleline/model/klineConstrants.dart';
import 'package:flutter/material.dart';

import 'grid/klinePriceGridWidget.dart';
import 'grid/klineVolumeGridWidget.dart';
import 'kline/KlineDateWidget.dart';
import 'kline/klineCandleCrossWidget.dart';
import 'kline/klineCandleInfoWidget.dart';
import 'kline/klineCandleWidget.dart';
import 'kline/klineLoadingWidget.dart';
import 'kline/klineMaLineWidget.dart';
import 'kline/klinePeriodSwitch.dart';
import 'kline/klineVolumeWidget.dart';

class KlineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _getTotalAspectRatio(
          context, kcandleAspectRatio, kVolumeAspectRatio, kPeriodAspectRatio),
      child: Container(
        color: kBackgroundColor,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  child: KlinePeriodSwitchWidget(),
                  aspectRatio: kPeriodAspectRatio,
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      KlinePriceGridWidget(), //绘制网格
                      KlineCandleWidget(), //绘制蜡烛
                      KlineMaLineWidget(YKMAType.MA5),
                      KlineMaLineWidget(YKMAType.MA10),
                      KlineMaLineWidget(YKMAType.MA30),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: kVolumeAspectRatio,
                  child: Stack(
                    children: <Widget>[
                      KlineVolumeGridWidget(),
                      KlineVolumeWidget(),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  child: KlineDateWidget(),
                )
              ],
            ),
            KlineCandleCrossWidget(),
            KlineCandleInfoWidget(),
            KlineLoadingWidget(),
          ],
        ),
      ),
    );
  }
}

double _getTotalAspectRatio(
    BuildContext context, double aspectRatio1, aspectRatio2, aspectRatio3) {
  return 1.05;
  if (aspectRatio1 == 0 || aspectRatio2 == 0 || aspectRatio3 == 0) {
    return 1;
  }
  double width = MediaQuery.of(context).size.width;
  // width/height1 = aspectRatio1; height1 = width/aspectRatio1;
  double height1 = width / aspectRatio1;
  double height2 = width / aspectRatio2;
  double heitht3 = width / aspectRatio3;
  return width / (height1 + height2 + heitht3);
}
