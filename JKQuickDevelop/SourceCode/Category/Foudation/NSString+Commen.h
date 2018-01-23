//
//  NSString+Commen.h
//  JKQuickDevelop
//
//  Created by dengjie on 2017/1/19.
//  Copyright © 2017年 dengjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Commen)

+ (NSString* )GetH5Url:(NSString *)url;

//是否为空
+ (BOOL)isEmpty:(NSString *)string;

//去除字符串前后的空白,不包含换行符
- (NSString *)trim;

//去除字符串中所有空白
- (NSString *)removeWhiteSpace;
- (NSString *)removeNewLine;

//将字符串以URL格式编码
- (NSString *)stringByUrlEncoding;

//以给定字符串开始,忽略大小写
- (BOOL)startsWith:(NSString *)str;
//以指定条件判断字符串是否以给定字符串开始
- (BOOL)startsWith:(NSString *)str Options:(NSStringCompareOptions)compareOptions;


//以给定字符串结束，忽略大小写
- (BOOL)endsWith:(NSString *)str;
//以指定条件判断字符串是否以给定字符串结尾
- (BOOL)endsWith:(NSString *)str Options:(NSStringCompareOptions)compareOptions;

//包含给定的字符串, 忽略大小写
- (BOOL)containsString:(NSString *)str;
//以指定条件判断是否包含给定的字符串
- (BOOL)containsString:(NSString *)str Options:(NSStringCompareOptions)compareOptions;

//判断字符串是否相同，忽略大小写
- (BOOL)equalsString:(NSString *)str;

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font breakMode:(NSLineBreakMode)breakMode align:(NSTextAlignment)alignment;
@end
