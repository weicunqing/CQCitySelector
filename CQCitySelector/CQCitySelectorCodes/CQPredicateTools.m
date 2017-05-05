//
//  CQPredicateTools.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/3.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQPredicateTools.h"

@implementation CQPredicateTools

+ (NSArray *)searchResultWithSourceData:(NSArray *)sourceData
                               Keywords:(NSString *)keywords {
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    // 获取关键字
    NSString *searchString = keywords;

    // 创建谓词
    NSPredicate *allStringsContainsTheSearchString = [NSPredicate predicateWithFormat:@"self contains [string] %@",searchString];
    
    // 删掉上一次的搜索内容, 保证每次搜索结果都是最新的一组数据
    if (tempArray.count != 0) {
        
        [tempArray removeAllObjects];
    }
    
    // 过滤
    tempArray = [NSMutableArray arrayWithArray:[sourceData filteredArrayUsingPredicate:allStringsContainsTheSearchString]];
    
    return tempArray;
}

@end
