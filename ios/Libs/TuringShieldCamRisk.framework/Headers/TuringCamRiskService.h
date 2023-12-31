//
//  TuringCamRiskService.h
//  TuringShieldCamRisk
//
//  Created by 徐森圣 on 2020/12/2.
//  Copyright © 2020 Tencent Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TuringShieldCamRisk/TuringServiceDefine.h>
#import <TuringShieldCamRisk/TuringServiceSettings.h>
#import <TuringShieldCamRisk/TuringCamRiskTask.h>






/// 这些常量值用于设置或获取context中的字典数据中的key。
typedef NSString * TuringCamRiskContextKey NS_EXTENSIBLE_STRING_ENUM;

/// 用于设置请求序列编号的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextRequestSequenceKey;

/// 用于设置meta data的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextMetaDataKey;

/// 用于设置接入渠道号的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextChannelKey;

/// 用于设置接入构建号的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSNumber *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextBuildNoKey;

/// 用于设置接入版本号的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextVersionKey;

/// 用于设置接入版本LC的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextLCKey;

/// 用于设置其它额外信息的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextExtraInfoKey;

/// 用于设置接入App ID的key，参见 `TuringCamRiskContextKey`。该key对应的值应为 NSString *。
extern TuringCamRiskContextKey const _Nonnull TuringCamRiskContextAppIDKey;


@interface TuringCamRiskService : NSObject

+ (void)setupTarsServerWithURL:(nonnull NSString *)URLString withChannelID:(int32_t)ChannelID TS_AVAILABLE_IF(TS_NETWORKING_TMF_SHARK_SUPPORTS);

/// 禁止直接生成实例
- (nonnull instancetype)init NS_UNAVAILABLE;

/// 所有服务均以此单例提供
+ (nonnull instancetype)sharedService;


/// 预连接服务器网络，以便加速后续请求的回应速度
+ (void)touchNetworking;

/// 设置调用相关的上下文。字典中用到的key，请参考`TuringCamRiskContextKey`及其常量定义
- (void)setupContext:(nonnull NSDictionary<TuringCamRiskContextKey, id> *)context;

/// 生成一个摄像头检测任务并接受TuringCamRiskService的管理。如果相同sceneIDID的任务已经生成，则会
/// 返回同一个任务实例，直到该实例被`- detatchTask:`释放。
/// @param sceneID 摄像头检测任务的场景ID
/// @discussion 如果sceneID为空，则该任务不会被TuringCamRiskService管理，也不需要调用
/// `- detatchTask:`释放
- (nonnull TuringCamRiskTask *)taskForSceneID:(nullable NSString *)sceneID;

/// 释放一个摄像头检测任务
/// @param task 要释放的任务实例
- (void)detatchTask:(nonnull TuringCamRiskTask *)task;

+ (nonnull NSDictionary *)SDKInfo;

@end

/// 设备实时风险标签
@interface TuringCamRiskService (RiskToken)

/// 获取实时风险标签
/// @param usingCache 是否使用缓存。YES表示由图灵盾SDK根据缓存策略，决定是否更新缓存；NO表示总是联网获取实时结果。
/// @param completion 获取结果的回调
/// @discussion 一般我们建议usingCache设置为YES。仅当在对风险检测要求特别高的场景下，才设置为NO。图灵盾SDK能有效管理缓存并确保缓存的检测安全效果，同时节省请求流量和服务计算成本。同时，由于您可能不够理解何时可以使用缓存而何时需要更新缓存，因此我们不建议客户端自行缓存我们的结果。
- (void)fetchRiskTokenUsingCache:(BOOL)usingCache WithCompletionHandler:(nonnull void(^)(NSString *_Nullable message, NSError *_Nullable error))completion TS_AVAILABLE_IF(TS_ENABLES_RISK_DETECT_FEATURE);

@end

@interface TuringCamRiskService (Debugging)

/// 设置是否使用测试服务器
/// @discussion 注意只能在未使用任何 TuringCamRiskService 的服务之前设置，否则某些正在进行中的
/// 服务可能会出现错误
@property (class, nonatomic) BOOL usesDebugServer TS_AVAILABLE_IF(__TS_OR(TS_NETWORKING_WUP_SUPPORTS, TS_NETWORKING_SHARK_SUPPORTS));

@end
