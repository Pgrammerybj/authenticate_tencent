//
//  WBCFGMSSLUtils.h
//  KYCGMSDK
//
//  Created by brownfeng on 2022/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define KYCGMSDKVersion @"0.1.2"

@interface WBCFGMSSLUtils : NSObject

+(BOOL)kycSM4Available;

+(void)sm4_encrypt_c1c3c2_demo;
+(void)sm4_decrypt_c1c3c2_demo;
#pragma mark - SM2

/**
 *  传入等待加密的NSdata, 以及 public key的PEM格式字符串
 *
 *  @param rawData      等待加密的二进制,
 *  @param base64PublicKey base64格式的 SM2Key, 长度88个字符, 二进制格式key长度64个字节
 *
 *  @return 返回加密以后的raw data
 */
+ (NSData *)kycSM2EncryptData:(NSData *)rawData publicKey:(NSString *)base64PublicKey;

#pragma mark - SM4

// sm4加密时需要的密钥: key 长度 16个字节, 128bit
+ (NSData *)kycSM4GenerateKey;

// sm4加密时需要初始向量: iv 长度 16个字节, 128bit
+ (NSData *)kycSM4GenerateIv;

/*
*  传入待加密的data, 以及加密 key
*
*  @param data      等待加密的二进制数据
*  @param key       sm4的密钥 - 16字节, 128bit!!!
*  @param iv        sm4加密使用的iv - 16字节, 128bit!!!
*
*  @return 返回加密以后的二进制数据
*/
+ (NSData *)kycSM4EncryptData:(NSData*)data key:(NSData*)keyData iv:(NSData*)ivData;

/*
*  传入待解密的二进制 data, 以及解密 key
*
*  @param data      等待解密的二进制数据
*  @param key       sm4的密钥 - 16字节, 128bit!!!
*  @param iv        sm4解密使用的iv - 16字节, 128bit!!!
*
*  @return 返回加密以后的二进制数据
*/
+ (NSData *)kycSM4DecryptData:(NSData*)data key:(NSData*)keyData iv:(NSData*)ivData;

@end

NS_ASSUME_NONNULL_END
