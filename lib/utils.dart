import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

export 'http_utils.dart';

double setSp(double fontSize) {
  return ScreenUtil().setHeight(fontSize) as double;
}

double setHeight(double height) => ScreenUtil().setHeight(height) as double;

double setWidth(double width) => ScreenUtil().setWidth(width) as double;

PageRoute<T> page<T>(WidgetBuilder builder) =>
    CupertinoPageRoute<T>(builder: builder);

///申请权限,此处仅为demo示范
Future<bool> requestPermission(final List<Permission> permissions) async {
  if (permissions == null || permissions.isEmpty) {
    return true;
  }

  final Map<Permission, PermissionStatus> permissionRequestResult =
      await permissions.request();

  final List<PermissionStatus> statusList =
      permissionRequestResult.values.toList();

  for (final PermissionStatus status in statusList) {
    if (status != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

bool isNullOrEmpty(dynamic s) {
  if (s == null) {
    return true;
  } else if (s is String) {
    return s.isEmpty;
  } else if (s is List<dynamic>) {
    return s.isEmpty;
  } else if (s is Map<dynamic, dynamic>) {
    return s.isEmpty;
  } else {
    return false;
  }
}


bool isPhoneNumber(String phone) {
  if (isNullOrEmpty(phone)) {
    return false;
  }
  final RegExp exp = RegExp(
      r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
  return exp.hasMatch(phone);
}

bool isCardId(String cardId) {
  if (isNullOrEmpty(cardId) || cardId.length != 18) {
    return false; // 位数不够
  }
  // 身份证号码正则
  final RegExp postalCode = RegExp(
      r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
  // 通过验证，说明格式正确，但仍需计算准确性
  if (!postalCode.hasMatch(cardId)) {
    return false;
  }
  //将前17位加权因子保存在数组里
  final List<String> idCardList = <String>[
    '7',
    '9',
    '10',
    '5',
    '8',
    '4',
    '2',
    '1',
    '6',
    '3',
    '7',
    '9',
    '10',
    '5',
    '8',
    '4',
    '2'
  ];
  //这是除以11后，可能产生的11位余数、验证码，也保存成数组
  final List<String> idCardYArray = <String>[
    '1',
    '0',
    '10',
    '9',
    '8',
    '7',
    '6',
    '5',
    '4',
    '3',
    '2'
  ];
  // 前17位各自乖以加权因子后的总和
  int idCardWiSum = 0;

  for (int i = 0; i < 17; i++) {
    final int subStrIndex = int.parse(cardId.substring(i, i + 1));
    final int idCardWiIndex = int.parse(idCardList[i]);
    idCardWiSum += subStrIndex * idCardWiIndex;
  }
  // 计算出校验码所在数组的位置
  final int idCardMod = idCardWiSum % 11;
  // 得到最后一位号码
  final String idCardLast = cardId.substring(17, 18);
  //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
  if (idCardMod == 2) {
    if (idCardLast != 'x' && idCardLast != 'X') {
      return false;
    }
  } else {
    //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
    if (idCardLast != idCardYArray[idCardMod]) {
      return false;
    }
  }
  return true;
}
