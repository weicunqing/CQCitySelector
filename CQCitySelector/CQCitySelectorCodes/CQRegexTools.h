//
//  CQRegexTools.h
//  CQRegexDemo
//
//  Created by Mac mini on 16/8/19.
//  Copyright © 2016年 yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQRegexTools : NSObject


#pragma mark - 什么是正则表达式

// 1. 正则表达式英文全称为 regular expression, 简称 regex, 由元字符和普通字符组成, 是用来操作 (字符串) 的一种逻辑公式

// 2. 元字符基本语法简介 : (区分大小写)
// (1)^ 和 $ : ^ 代表匹配以某某某开头的字符串, $ 代表匹配以某某某结束的字符串
// eg : ^one, 可匹配到类似("oneTwoThree", "one cat", ...); Three$, 可匹配到类似("oneTwoThree", "Three", ...)

// (2)*, +, ? {num1, num2} : 代表紧贴着这个元字符的前面的那个字符重复出现的次数. * 代表该字符出现零次或者更多次([0,+∞]取整), + 代表该字符出现一次或者更多次([1,+∞]取整), ? 代表该字符出现零次或者一次([0,1]取整), {num1, num2} 代表该字符串出现([num1, num2]取整)次
// eg : "ab*", 代表匹配 a 后面跟着零个或多个 b的("a", "ab", "abb", ...); "ab+", 代表匹配 a 后面跟着一个或多个 b的("ab", "abb"...); "ab?", 代表匹配 a 后面跟着零个或一个 b的("a", "ab", ...); "ab{3}" 代表匹配 a 后面跟着三个 b的("abbb"); "ab{3, }" 代表匹配 a 后面跟着至少三个 b的("abbb", "abbbb", ...); "ab{3, 5}" 代表匹配 a 后面跟着三到五个 b的("abbb", "abbbb", "abbbbb")

// (3)[] : 代表从方括号内任意的 1~N 个字符
// eg : “[ab]“, 代表 a 或 b; [a-zA-Z], 代表所有的字母; "[0-9]a", 代表 a 前有一个任意的数字

// (4)^ 在 [] 中 : 表示不希望出现的字符, ^ 应写在方括号里的第一位
// eg : “@[^a-zA-Z]@”, 代表两个 @ 之间不应该出现字母

// (5). : 代表匹配除 \r(回车)和 \n(换行) 之外的任意单个字符
// eg : "r.t", 可匹配 rat, rut, ..., 但是匹配不到 root; 而 "r.{2}t" 可匹配到 ruut, root, ...

// (6)| : 代表或操作
// eg : "(a|bcd)ef" , 可匹配到 aef 或者 abcdef

// (7)\ : 它是一个引用符, 用来将它后面紧跟着的元字符当作普通的字符来进行匹配
// eg : \$, 代表匹配美元符号, 而不再是字符尾部

// (8)\num : 代表 \num 之前紧贴着的那个字符出现的次数, 类似于上面的 *, +, ?, {}
// eg : "10\{1, 2}” : 代表数字 1 后面跟着 1 或者 2 个 0,("10", "100")

// (9)另外还有一些预先定义的元字符 :
// \d, 代表匹配一个数字字符, 等价于[0-9]; \D, 代表匹配一个非数字字符, 等价于[^0-9]
// \s, 代表匹配一个空白字符; \S, 代表匹配一个非空白字符
// \w, 代表匹配包括下划线的任何单词字符, 等价于“[A-Za-z0-9_]”; \W, 代表匹配任何非单词字符, 等价于“[^A-Za-z0-9_]”


#pragma mark - 为什么要是用正则表达式

// 在 iOS 开发中我们通常使用正则表达式来检测指定的字符串是否符合我们想要的某种格式, 它可以仅仅通过一段非常非常简短的表达式语句, 就快速准确地实现一个非常复杂的业务逻辑, 极大地提高开发效率


#pragma mark - iOS 开发中常用的正则表达式, 以后实际用到什么再补上来

// 1. 验证手机号
+ (BOOL)validatePhoneNum:(NSString *)phoneNum;

// 2. 验证邮箱
+ (BOOL)validateEmail:(NSString *)email;

// 3. 验证用户名
+ (BOOL)validateUsername:(NSString *)username;

// 4. 验证密码
+ (BOOL)validatePassword:(NSString *)password;

// 5. 验证身份证号
+ (BOOL)validateIDCard:(NSString *)idCard;

// 6. 验证汉字(必须输入汉字, 比如国内实名认证的时候)
+ (BOOL)validateChinese:(NSString *)chinese;

// 7. 验证邮编
+ (BOOL)validatePostCode:(NSString *)postCode;


@end
