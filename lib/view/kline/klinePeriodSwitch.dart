/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-23 18:44:59
 * @LastEditTime: 2019-08-21 16:02:17
 */

import 'package:candleline/bloc/KlineBloc.1.dart';
import 'package:candleline/bloc/klineBlocProvider.dart';
import 'package:candleline/model/klineConstrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KlinePeriodSwitchWidget extends StatefulWidget {
  @override
  _KlinePeriodSwitchWidgetState createState() =>
      _KlinePeriodSwitchWidgetState();
}

class _KlinePeriodSwitchWidgetState extends State<KlinePeriodSwitchWidget> {
  List<String> periodList = kPeriodList;
  List<String> periodTitleList = kPeriodTitleList;
  int currentIndex = kDefaultPeriodIndex;
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    double screenWidth = bloc.screenWidth;
    double height = kPeriodHeight;
    double width = screenWidth / periodList.length;
    Widget _listView() {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: periodList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: width,
              alignment: Alignment.center,
              child: CupertinoButton(
                pressedOpacity: 0.7,
                padding: EdgeInsets.all(0),
                child: Text(
                  '${periodTitleList[index]}',
                  style: TextStyle(
                      fontSize: 12,
                      // fontWeight: FontWeight.w700,
                      color: currentIndex == index
                          ? hSelectedTextColor
                          : hDefaultTextColor),
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = index;
                  });
                  bloc.periodSwitchSinkAdd(periodList[index]);
                },
              ),
            );
          });
    }

    double indicatorWidth = (width * 2 / 3).ceilToDouble();
    double indicatorHeight = 2;
    double indicatorTopMargin = height - indicatorHeight * 2;
    double left = (currentIndex * width + indicatorWidth / 4).ceilToDouble();

    Widget _indicator() {
      return AnimatedPositioned(
        left: left,
        child: Container(
          height: indicatorHeight,
          width: indicatorWidth,
          margin: EdgeInsets.only(top: indicatorTopMargin),
          color: hIndicatorColor,
        ),
        duration: Duration(milliseconds: 200),
      );
    }

    return Container(
        width: screenWidth,
        height: height,
        child: Stack(
          children: <Widget>[_listView(), _indicator()],
        ));
  }
}
