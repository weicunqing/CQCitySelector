//
//  CQCitySelectViewController.h
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CQCitySelectBlock)(NSString *cityName);

@interface CQCitySelectViewController : UIViewController

@property (strong, nonatomic) UIColor *tintColor;// 分区索引及搜索关键字的颜色
@property (strong, nonatomic) CQCitySelectBlock block;// 选择城市之后的回调

@end
