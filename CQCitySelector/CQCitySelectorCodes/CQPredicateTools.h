//
//  CQPredicateTools.h
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/3.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQPredicateTools : NSObject

/**
 根据源数据和关键字过滤内容并返回
 
 @param sourceData  源数据
 @param keywords    关键字
 
 @return    过滤之后的内容
 */
+ (NSArray *)searchResultWithSourceData:(NSArray *)sourceData
                               Keywords:(NSString *)keywords;

@end
