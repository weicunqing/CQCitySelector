//
//  CQSearchBarView.h
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)();
typedef void(^SearchResultBlock)(NSString *string);

@interface CQSearchBarView : UIView

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) SearchBlock didBeginSearch;// 开始搜索
@property (strong, nonatomic) SearchResultBlock textDidChange;// 搜索内容发生改变
@property (strong, nonatomic) SearchBlock didCancelSearch;// 取消搜索


/**
 取消搜索
 */
- (void)cancelSearch;

@end
