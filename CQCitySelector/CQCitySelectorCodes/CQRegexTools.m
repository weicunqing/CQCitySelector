//
//  CQRegexTools.m
//  CQRegexDemo
//
//  Created by Mac mini on 16/8/19.
//  Copyright © 2016年 yiyi. All rights reserved.
//

#import "CQRegexTools.h"

@implementation CQRegexTools


#pragma mark - 现在登录的话, 无非就是这三种登录方式, 可用

+ (BOOL)validatePhoneNum:(NSString *)phoneNum {
    
    NSString *regexString = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:phoneNum];
}

+ (BOOL)validateEmail:(NSString *)email {
    
    NSString *regexString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:email];
}

+ (BOOL)validateUsername:(NSString *)username {
    
    // 用户名是 6~16 个字母和数字组成的, 区别于用户的昵称, 如 qq 账号和 qq 昵称
    NSString *regexString = @"^[A-Za-z0-9]{6,16}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:username];
}

+ (BOOL) validatePassword:(NSString *)passWord {
    
    // 密码也是由 6~16 个字母和数字组成的
    NSString *regexString = @"^[A-Za-z0-9]{6,16}+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:passWord];
}


#pragma mark - 实名认证的时候, 可用

+ (BOOL)validateIDCard:(NSString *)idCard {
    
    // 15 位或 18 位数字, 好草率, 嗯?
    NSString *regexString = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:idCard];
}

+ (BOOL)validateChinese:(NSString *)chinese {
    
    // 必须得是汉字
    NSString *regexString = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:chinese];
}


#pragma mark - 收货地址填邮编的时候, 可用, 万一后台不给那不就得自己写了吗

+ (BOOL)validatePostCode:(NSString *)postCode {
    
    // 国内邮编为 6 位数字, 草率, 嗯?
    NSString *regexString = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [predicate evaluateWithObject:postCode];
}


@end
