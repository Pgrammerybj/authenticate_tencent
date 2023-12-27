import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'next_button.dart';
import 'utils.dart';
import 'app_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

///实名认证
class AuthPage extends StatefulWidget {
  const AuthPage();

  @override
  State<StatefulWidget> createState() {
    return AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  bool isSelect = false;

  String name = "";
  String cardId = "";

  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    requestPermission(<Permission>[
      Permission.camera,
      Permission.microphone,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 840),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children:<Widget>[
                const AppView(
                  title: '-青兮-人脸识别',
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: setHeight(48),
                      ),
                      Container(
                        height: setHeight(18),
                      ),
                      Container(
                        child: Text(
                          '人脸识别验证',
                          style: TextStyle(
                              fontSize: setSp(20),
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        alignment: Alignment.center,
                      ),
                      getCenter(),
                      Container(
                        height: setHeight(50),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: setWidth(24)),
                        child: NextButton(
                          isCanClick: (!isSubmit &&
                              !isNullOrEmpty(name) &&
                              isCardId(cardId)),
                          text: '开始人脸识别验证',
                          onTap: () async {
                            setState(() {
                              isSubmit = true;
                            });
                            final Map<dynamic, dynamic> result = await startFaceService(context, name, cardId);
                            Fluttertoast.showToast(
                              msg: result['desc'],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              // backgroundColor: "#e74c3c",
                              // textColor: '#ffffff'
                            );
                            setState(() {
                              isSubmit = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: setHeight(20),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: setWidth(24)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  height: setHeight(2),
                                ),
                              ],
                            ),
                            Container(
                              width: setWidth(10),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
      },
    );

  }

  Widget getCenter() {
    return Column(
        children: <Widget>[
          Container(
            height: setHeight(14),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: setWidth(24)),
            width: setWidth(375),
            height: setHeight(96),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: setHeight(1), color: const Color(0xFFE5E5E5)))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: setHeight(8),
                ),
                Text(
                  '姓名',
                  style: TextStyle(
                    fontSize: setSp(14),
                    color: const Color(0xFF888888),
                  ),
                ),
                Container(
                  height: setHeight(2),
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: '请输入姓名',
                    hintStyle: TextStyle(
                      fontSize: setSp(20),
                      color: const Color(0xFF888888),
                    ),
                  ),
                  style: TextStyle(fontSize: setSp(20), color: Colors.black),
                  onChanged: (String text) {
                    setState(() {
                      name = text;
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: setWidth(24)),
            width: setWidth(375),
            height: setHeight(96),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: setHeight(1), color: const Color(0xFFE5E5E5)))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: setHeight(8),
                ),
                Text(
                  '身份证号',
                  style: TextStyle(
                    fontSize: setSp(14),
                    color: const Color(0xFF888888),
                  ),
                ),
                Container(
                  height: setHeight(2),
                ),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: '请输入身份证号',
                    hintStyle: TextStyle(
                      fontSize: setSp(20),
                      color: const Color(0xFF888888),
                    ),
                  ),
                  style: TextStyle(fontSize: setSp(20), color: Colors.black),
                  onChanged: (String text) {
                    setState(() {
                      cardId = text;
                    });
                  },
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(18),
                  ],
                )
              ],
            ),
          ),
        ],
      );  
  }
}
