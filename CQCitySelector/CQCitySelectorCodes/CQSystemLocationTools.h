//
//  CQSystemLocationTools.h
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/3.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@protocol CQSystemLocationToolsDelegate <NSObject>

@optional


/**
 定位成功回调
 
 @param currentLoaction 当前位置信息
 */
- (void)didFinishLocatingWithLocation:(CLLocation *)currentLoaction;

/**
 定位成功回调
 
 @param placemark 地理反编码后的信息
 */
- (void)didFinishLocatingWithPlacemark:(CLPlacemark *)placemark;

/**
 没有定位权限的回调
 
 @param message 提示信息
 */
- (void)refusedToLocateWithMessage:(NSString *)message;

/**
 定位失败的回调
 
 @param message 提示信息
 */
- (void)didFailLocatingWithMessage:(NSString *)message;

@end

@interface CQSystemLocationTools : NSObject

@property (assign, nonatomic) id<CQSystemLocationToolsDelegate> delegate;


+ (instancetype)sharedCQSystemLocationTools;


@end
