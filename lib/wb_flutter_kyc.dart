
import 'dart:async';

import 'package:flutter/services.dart';

class WbFlutterKyc {
  static const MethodChannel _channel = MethodChannel('com.tencent.cloud.huiyansdkface.kyc/face');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }


  static Future<Map<dynamic, dynamic>> auth(String faceId, String order, String nonce, String sign,
      String userId, String appId, String licence) async {
    final Map<String, dynamic> config = {
      'faceId': faceId,
      'order': order,
      'nonce': nonce,
      'sign': sign,
      'userId': userId,
      'appId': appId,
      'mode':'reflect',
      'type':'idCard',
      'licence': licence,
      'config': {
        'showSuccessPage': '0', //是否展示成功页面
        'showFailurePage': '0', //是否展示失败页面
        'recordVideo': '0', //是否录制视频
        'playVoice': '0', //是否播放语音提示
        'theme': '1', //sdk皮肤设置，0黑色，1白色
      }
    };
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('startFaceService', config);
    return result;
  }
}
