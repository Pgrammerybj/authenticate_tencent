import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'authenticate_tencent.dart';

///实名认证
///https://cloud.tencent.com/document/product/1007/35866
Future<Map<dynamic, dynamic>> startFaceService(
    BuildContext context, String name, String idNo) async {
  const String userId = 'F3WP4JO46fw8yk01jbWF43i2bd4hd49R';
  const String order = 'cb00710215875508772941002';
  const String nonce = 'F3WP4JO46fw8yk01jbWF43i2bd4hd49R';
  const String appId = 'TIDAH5vJ';
  const String androidLicense ='mPKQ4VCX4evJDSzf6B1wgNLdpmRykiEXwsbxHET8f4p6nkg5OXJ4TEdLaTKdhsSjc5TfXfl3xrSCQeCH92UWV/XJzcPwBNoUTGgW+3T9OsCSvOmu+h6QJ9Rf72wtjPFC6GxVTIQkuyXn3uhuqcIxLweZ4y0KMpSoEB+o9O8rP2dBJ1VY7JN9ZU88//4e5pi0DuKF7X9JEM/a7ufLVWh6+KVGkCu//PgrzxXEeChKqublOHZUt2++h2+rhbXzC4sQx4iR+Nly6+KYsDoyff9Ean5d7MSJCGfwp5lkZlcYU4s90EUIYS271xfIMVSi3uDXPCgKjunBA8PKtn9V1pfqfA==';
  const String iosLicense =
      'NwKivlx4CuaA0r1Ri/x7VGugcN5bfIUm9Q0ZfUHmr2R6mjwuZUGRUNL+ydQhfRjaCl4s+YdUnVPxGGBfxCeSYpHk0AZIRUHUy5TETKUlSKrolSR+svPde8ZImxQhXIK5Tyr+zweHGZpPzOsuYglLuPeECYNGtDfw+4pTEIXFkwBbUMuoAt/RcLBxGpjB8Ol5meMP/8A10YfWJwPvuhVttMxXX7fIqPVxrC7bMRG8Y0AXUJQtJmFR8u35BvCY1YZYrQ3puOHTVvAdOJH53+w+kKVt1sMzVaa/1qnjgNHtC8DkHJ6+FJx5nOn2Etah7oWKE4dQrd+HOjXQeWFRdb9/ww==';
  const String urlString = 'https://miniprogram-kyc.tencentcloudapi.com/api/server/getfaceid';
  final String sign = await getSign(context, appId, userId, nonce);
  if (sign == '') {
    return {'success': '0', 'desc': 'get sign error'};
  }
  try {
    Dio dio = Dio();
    final Map<String, dynamic> headers = {"content-type": "application/json"};
    // dio.options.headers.remove("content-type");
    dio.options.headers.addAll(headers);
    // dio.options.contentType = 'application/json';
    final Map<String, dynamic> params = {
      'webankAppId': appId,
      'orderNo': order,
      'name': name,
      'idNo': idNo,
      'userId': userId,
      'srcPhotoSrc': '',
      'srcPhotoType': '',
      'nonce': nonce,
      'version': '1.0.0',
      'sign': sign
    };
    var body = utf8.encode(json.encode(params));
    Response response = await dio.post(urlString, data: params);
    var data = json.decode(response.toString());
    var result = data['result'];
    var license = Platform.isAndroid ? androidLicense : iosLicense;
    final String faceId = result['faceId'];
    if (faceId != null) {
      final Map<dynamic, dynamic> result = await AuthenticateTencent.auth(faceId, order, nonce, sign, userId, appId, license);
//        final Map<dynamic, dynamic> result = await Faceplugin.auth(faceId, order, nonce, sign, userId, appId, license);
      final String success = result['success'];
      return result;
    } else {
      return {'success': '0', 'desc': 'get faceid error'};
    }
  } catch (exception) {
    print('exc:$exception');
    return {'success': '0', 'desc': 'network error'};
  }
}

Future<String> getSign(
    BuildContext context, String appId, String userId, String nonce) async {
  try {
    Dio dio = Dio();
    const String urlString =
        'https://miniprogram-kyc.tencentcloudapi.com/ems-partner/cert/signature';
    Response response = await dio.get(urlString,
        queryParameters: {'appid': appId, 'userid': userId, 'nonce': nonce});
    var data = json.decode(response.toString());
    return data['sign'] ?? "";
  } catch (exception) {
    print('exc:$exception');
    return '';
  }
}
