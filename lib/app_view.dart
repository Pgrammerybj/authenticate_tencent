import 'package:flutter/material.dart';
import 'utils.dart';

///标题栏
class AppView extends StatelessWidget {
  const AppView({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: setWidth(375),
      height: setHeight(88),
      color: Colors.white,
      padding: EdgeInsets.only(top: setHeight(44)),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
                width: setWidth(372),
                ),
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: setSp(18),
                fontWeight: FontWeight.w600),
          ),
          Flexible(
              child: Container(
            width: setWidth(372),
          )),
        ],
      ),
    );
  }
}
