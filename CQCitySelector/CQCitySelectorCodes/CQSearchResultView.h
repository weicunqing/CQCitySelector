//
//  CQSearchResultView.h
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapViewBlock)();
typedef void(^ScrollBlock)();
typedef void(^SelectCityBlock)(NSString *cityName);

@interface CQSearchResultView : UIView

@property (strong, nonatomic) UITableView *searchResultTableView;

@property (strong, nonatomic) TapViewBlock tapView;// 点击空白处
@property (strong, nonatomic) ScrollBlock scroll;// 搜索结果滚动时

@property (strong, nonatomic) NSString *keywords;// 搜索关键字
@property (strong, nonatomic) UIColor *keywordsColor;// 搜索关键字颜色
@property (strong, nonatomic) NSMutableArray *searchResultArray;// 搜索结果
@property (strong, nonatomic) SelectCityBlock selectCityBlock;// 点击搜索结果回调

@end
