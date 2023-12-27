package com.mengtu.saywo.authenticate_tencent;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;


import com.tencent.cloud.huiyansdkface.facelight.api.WbCloudFaceContant;
import com.tencent.cloud.huiyansdkface.facelight.api.WbCloudFaceVerifySdk;
import com.tencent.cloud.huiyansdkface.facelight.api.listeners.WbCloudFaceVerifyLoginListener;
import com.tencent.cloud.huiyansdkface.facelight.api.listeners.WbCloudFaceVerifyResultListener;
import com.tencent.cloud.huiyansdkface.facelight.api.result.WbFaceError;
import com.tencent.cloud.huiyansdkface.facelight.api.result.WbFaceVerifyResult;
import com.tencent.cloud.huiyansdkface.facelight.process.FaceVerifyStatus;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


/** AuthenticateTencentPlugin */
public class AuthenticateTencentPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware {

  private static final String TAG = "MainActivity";
  private static final String FACE_CHANNEL = "com.mengtu.saywo.authenticate";
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FACE_CHANNEL);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("startFaceService")) {
      String faceId = call.argument("faceId");
      String orderNo = call.argument("order");
      String nonce = call.argument("nonce");
      String sign = call.argument("sign");
      String userId = call.argument("userId");
      String appId = call.argument("appId");
      //对比类型：身份证/仅活体
      String type = call.argument("type");
      String licence = call.argument("licence");

      Map<String, String> config = call.argument("config");

      openCloudFaceService(faceId, orderNo, appId, nonce, userId, sign, type, licence, config, result);
    } else {
      result.notImplemented();
    }
  }


  private void openCloudFaceService(String faceId, String order, String appId, String nonce, String userId, String sign,
                                    String type, String keyLicence, Map<String, String> config, final MethodChannel.Result callbackResult) {
    Bundle data = new Bundle();
    WbCloudFaceVerifySdk.InputData inputData = new WbCloudFaceVerifySdk.InputData(
            faceId,
            order,
            appId,
            "1.0.0",
            nonce,
            userId,
            sign,
            FaceVerifyStatus.Mode.GRADE,
            keyLicence);

    boolean isShowSuccess = config.get("showSuccessPage").equals("0") ? false : true;
    boolean isShowFail = config.get("showFailurePage").equals("0") ? false : true;
    boolean isRecordVideo = config.get("recordVideo").equals("0") ? false : true;
    boolean isPlayVoice = config.get("playVoice").equals("0") ? false : true;
    String color = config.get("theme").equals("0") ? WbCloudFaceContant.BLACK : WbCloudFaceContant.WHITE;
    String faceVerifyCompreType = getFaceVerifyCompareType(type);

    data.putSerializable(WbCloudFaceContant.INPUT_DATA, inputData);
    //是否展示刷脸成功页面，默认展示
    data.putBoolean(WbCloudFaceContant.SHOW_SUCCESS_PAGE, isShowSuccess);
    //是否展示刷脸失败页面，默认展示
    data.putBoolean(WbCloudFaceContant.SHOW_FAIL_PAGE, isShowFail);
    //颜色设置
    data.putString(WbCloudFaceContant.COLOR_MODE, color);
    //是否需要录制上传视频 默认需要
    data.putBoolean(WbCloudFaceContant.VIDEO_UPLOAD, isRecordVideo);
    //是否播放提示音，默认播放
    data.putBoolean(WbCloudFaceContant.PLAY_VOICE, isPlayVoice);
    //设置选择的比对类型  默认为权威源对比
    //公安网纹图片比对 WbCloudFaceVerifySdk.ID_CRAD
    //默认公安网纹图片比对
    data.putString(WbCloudFaceContant.COMPARE_TYPE, faceVerifyCompreType);

    WbCloudFaceVerifySdk.getInstance().initSdk(activity, data, new WbCloudFaceVerifyLoginListener() {
      @Override
      public void onLoginSuccess() {
        Log.i(TAG, "onLoginSuccess");

        WbCloudFaceVerifySdk.getInstance().startWbFaceVerifySdk(activity, new WbCloudFaceVerifyResultListener() {
          @Override
          public void onFinish(WbFaceVerifyResult result) {
            if (result != null) {
              if (result.isSuccess()) {
                Log.d(TAG, "刷脸成功! Sign=" + result.getSign() + "; liveRate=" + result.getLiveRate() +
                        "; similarity=" + result.getSimilarity() + "userImageString=" + result.getUserImageString());

                Map<String, String> temp = new HashMap<String, String>();
                temp.put("success", "1");
                temp.put("desc", result.toString());
                callbackResult.success(temp);
              } else {
                WbFaceError error = result.getError();
                if (error != null) {
                  Log.d(TAG, "刷脸失败！domain=" + error.getDomain() + " ;code= " + error.getCode()
                          + " ;desc=" + error.getDesc() + ";reason=" + error.getReason());
                  if (error.getDomain().equals(WbFaceError.WBFaceErrorDomainCompareServer)) {
                    Log.d(TAG, "对比失败，liveRate=" + result.getLiveRate() +
                            "; similarity=" + result.getSimilarity());
                  }
                } else {
                  Log.e(TAG, "sdk返回error为空！");
                }
                Map<String, String> temp = new HashMap<String, String>();
                temp.put("success", "0");
                temp.put("desc", result.toString());
                callbackResult.success(temp);
              }
            } else {
              Log.e(TAG, "sdk返回result为空！");

              Map<String, String> temp = new HashMap<String, String>();
              temp.put("success", "0");
              temp.put("desc", result.toString());
              callbackResult.success(temp);
            }
          }
        });
      }

      @Override
      public void onLoginFailed(WbFaceError error) {
        Log.i(TAG, "onLoginFailed!");
        if (error != null) {
          Log.d(TAG, "登录失败！domain=" + error.getDomain() + " ;code= " + error.getCode()
                  + " ;desc=" + error.getDesc() + ";reason=" + error.getReason());
        } else {
          Log.e(TAG, "sdk返回error为空！");
        }

        Map<String, String> temp = new HashMap<String, String>();
        temp.put("success", "0");
        temp.put("desc", error.toString());
        callbackResult.success(temp);


      }
    });
  }

  private String getFaceVerifyCompareType(String type) {
    switch (type) {
      case "idCard":
        return WbCloudFaceContant.ID_CARD;
      case "none":
        return WbCloudFaceContant.NONE;
      default:
        return WbCloudFaceContant.ID_CARD;
    }
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

}
