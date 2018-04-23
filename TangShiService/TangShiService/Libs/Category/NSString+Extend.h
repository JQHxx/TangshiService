//
//  NSString+Extend.h
//  VIFI
//
//  Created by jiangqin on 15/5/14.
//  Copyright (c) 2015年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extend)


/**
 *  md5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)MD5;

/*
 *十六进制转十进制
 *
 */
-(NSString *) numberHexString;

/**
 *  url encode 和decode
 *
 */
- (NSString *)stringEncode;
- (NSString *)stringDecode;

/**
 *  动态确定文本的宽高
 *
 *  @param size 宽高限制，用于计算文本绘制时占据的矩形块。
 *  @param font 字体
 *
 *  @return 文本绘制所占据的矩形空间
 */
- (CGSize)boundingRectWithSize:(CGSize)size withTextFont:(UIFont *)font;
/**
 *  简单计算textsize
 *
 *  @param width 传入特定的宽度
 *  @param font  字体
 */
- (CGSize)sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font;
/**
 *  base64加密解密
 *
 *  @return 加密或解密后的字符串
 */
- (NSString *)base64;
- (NSString *)base64Decoded;

/**
 *  邮箱验证
 *
 *  @return 是否是邮箱
 */
- (BOOL)isEmail;

/**
 *  手机号码验证
 *
 *  @return 是否是手机号码
 */
- (BOOL)isPhoneNumber;

/**
 *  身份证号验证
 *
 *  @return 是否是身份证
 */
- (BOOL)isIdentifyCard;

/*
 *   获取APP版本号
 */
+ (NSString *)getAppVersion;


@end
