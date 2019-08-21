/*
 * @Description: 
 * @Author: zhaojijin
 * @LastEditors: Please set LastEditors
 * @Date: 2019-04-23 21:38:13
 * @LastEditTime: 2019-08-21 16:40:37
 */
import 'package:candleline/bloc/KlineBloc.1.dart';
import 'package:candleline/bloc/klineBlocProvider.dart';
import 'package:candleline/model/klineConstrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KlineLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc bloc = KlineBlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
      stream: bloc.klineShowLoadingStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        bool show = snapshot.data == null ? true : snapshot.data;
        Widget loading = loadingWidget != null
            ? loadingWidget
            : CupertinoActivityIndicator();

        return Container(child: Center(child: show ? loading : null));
      },
    );
  }
}
