//
//  CQCityTableViewCell.h
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/2.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CQCityCollectionViewCellBlock)(NSString *cityName);

@interface CQCityTableViewCell : UITableViewCell

@property (strong, nonatomic) NSArray *cityArray;

@property (strong, nonatomic) CQCityCollectionViewCellBlock block;

@end
