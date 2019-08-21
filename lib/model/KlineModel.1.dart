/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-16 14:30:22
 * @LastEditTime: 2019-08-20 09:28:49
 */

import 'package:flutter/material.dart';

import 'klineConstrants.dart';
// import "package:intl/intl.dart";

class Market {
  Market(this.open, this.high, this.low, this.close, this.vol, this.id,
      {this.isShowCandleInfo});
  double open;
  double high;
  double low;
  double close;
  double vol;
  int id;

  //指标线数据
  double priceMa1;
  double priceMa2;
  double priceMa3;

  // 十字交叉点
  Offset offset;
  double candleWidgetOriginY;
  double gridTotalHeight;

  bool isShowCandleInfo;
  List<String> candleInfo() {
    double limitUpDownAmount = close - open;
    double limitUpDownPercent = (limitUpDownAmount / open) * 100;
    String pre = '';
    if (limitUpDownAmount < 0) {
      pre = '';
    } else if (limitUpDownAmount > 0) {
      pre = '+';
    }
    String limitUpDownAmountStr = '$pre${limitUpDownAmount.toStringAsFixed(2)}';
    String limitPercentStr = '$pre${limitUpDownPercent.toStringAsFixed(2)}%';
    return [
      readTimestamp(id),
      open.toStringAsPrecision(kGridPricePrecision),
      high.toStringAsPrecision(kGridPricePrecision),
      low.toStringAsPrecision(kGridPricePrecision),
      close.toStringAsPrecision(kGridPricePrecision),
      limitUpDownAmountStr,
      limitPercentStr,
      vol.toStringAsPrecision(kGridPricePrecision)
    ];
  }

  void printDesc() {
    print(
        'open :$open close :$close high :$high low :$low vol :$vol offset: $offset');
  }
}

String readTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String time =
      '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  if (date.hour == 0 && date.minute == 0) {
    time =
        '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  return time;
}
