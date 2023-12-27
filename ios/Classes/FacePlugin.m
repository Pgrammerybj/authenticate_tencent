//
//  FacePlugin.m
//
//  Update on 2023/11/30 with Flutter 3.16.1.

#import "FacePlugin.h"
#import <TencentCloudHuiyanSDKFace/WBFaceVerifyCustomerService.h>

@interface FacePlugin () <WBFaceVerifyCustomerServiceDelegate>

@property (nonatomic, copy) FlutterResult result;

@end

@implementation FacePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *faceChannel = [FlutterMethodChannel
        methodChannelWithName:@"com.tencent.cloud.huiyansdkface.kyc/face"
              binaryMessenger:registrar.messenger];
    FacePlugin *facePlugin = [[FacePlugin alloc] init];
    [registrar addMethodCallDelegate:facePlugin channel:faceChannel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"startFaceService"]) {
        self.result = result;
        NSDictionary *params = call.arguments;
#if DEBUG
        NSLog(@"%@", params);
#endif
        NSDictionary *config = params[@"config"];
        WBFaceVerifySDKConfig *sdkConfig = [WBFaceVerifySDKConfig sdkConfig];
        sdkConfig.mute = [config[@"playVoice"] boolValue];
        sdkConfig.recordVideo = [config[@"recordVideo"] boolValue];
        sdkConfig.theme = (WBFaceVerifyTheme)[config[@"theme"] integerValue];
        sdkConfig.bundlePath = [NSBundle bundleForClass:self.class].bundlePath;
        [WBFaceVerifyCustomerService sharedInstance].delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[WBFaceVerifyCustomerService sharedInstance] initSDKWithUserId:params[@"userId"] nonce:params[@"nonce"] sign:params[@"sign"] appid:params[@"appId"] orderNo:params[@"order"] apiVersion:@"1.0.0" licence:params[@"licence"] faceId:params[@"faceId"] sdkConfig:sdkConfig success:^{
                [[WBFaceVerifyCustomerService sharedInstance] startWbFaceVeirifySdk];
            } failure:^(WBFaceError *error) {
#if DEBUG
                NSLog(@"%@", error.description);
#endif
                self.result(@{@"success": @"0", @"desc": error.desc});
            }];
        });
    }
}

- (void)wbfaceVerifyCustomerServiceDidFinishedWithFaceVerifyResult:(WBFaceVerifyResult *)faceVerifyResult {
    if (faceVerifyResult.isSuccess) {
        NSString *message = [NSString stringWithFormat:@"liveRate: %@, similarity: %@", faceVerifyResult.liveRate, faceVerifyResult.similarity];
        self.result(@{@"success": @"1", @"desc": message});
    } else {
        NSString *message = [NSString stringWithFormat:@"%@, liveRate:%@, similarity:%@, sign: %@", faceVerifyResult.error.desc, faceVerifyResult.liveRate, faceVerifyResult.similarity, faceVerifyResult.sign];
        self.result(@{@"success": @"0", @"desc": message});
    }
}
@end
