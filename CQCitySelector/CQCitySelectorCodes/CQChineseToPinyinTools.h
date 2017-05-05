#import <UIKit/UIKit.h>

/**
 GB2312 编码中每个汉字都可以用一个二维坐标定位, 因此我们可以通过建立一个二维表来实现中文和拼音的对应关系. 当然我们会忽略一些特殊情况, 比如汉 字的多音字问题
 */


@interface CQPinyinSort : NSObject

@end

@interface CQChineseToPinyinTools : NSObject

/**
 汉字转拼音
 
 @param chinese 需要转化的汉字
 
 @return    返回大写拼音
 */
+ (NSString *)chineseToPinyinWithChinese:(NSString *)chinese;

@end

