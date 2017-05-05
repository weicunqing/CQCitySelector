//
//  CQSystemLocationTools.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/3.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQSystemLocationTools.h"

@interface CQSystemLocationTools ()<NSCopying, NSMutableCopying, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;// 定位管理类
@property (strong, nonatomic) CLGeocoder *geocoder;// 位置编码与反编码类

@end

@implementation CQSystemLocationTools


#pragma mark - 单例

static CQSystemLocationTools *systemLocationTools = nil;

+ (instancetype)sharedCQSystemLocationTools {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        systemLocationTools = [[CQSystemLocationTools alloc] init];
    });
    
    return systemLocationTools;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized(systemLocationTools) {
        
        if (!systemLocationTools) {
            
            systemLocationTools = [super allocWithZone:zone];
        }
        
        return systemLocationTools;
    }
}

- (instancetype)init {
    
    @synchronized(systemLocationTools) {
        
        self = [super init];
        if (self != nil) {
            
            [self startLocating];
        }
        
        return self;
    }
}

- (instancetype)copyWithZone:(NSZone *)zone {
    
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    
    return self;
}


#pragma mark - systemLocation

- (void)startLocating {
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {// 申请定位权限
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy= kCLLocationAccuracyBest;// 定位效果
    self.locationManager.distanceFilter = kCLDistanceFilterNone;// 多少米定位一次
    self.locationManager.delegate = self;

    self.geocoder = [[CLGeocoder alloc] init];
    
    [self.locationManager startUpdatingLocation];// 开始定位    
}

- (void)stopLocating {
    
    [self.locationManager stopUpdatingLocation];
}

// 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLoaction = [locations lastObject];
//    NSLog(@"当前位置 : 纬度===%f, 经度===%f, 海拔===%f, 航向===%f, 行走速度===%f", currentLoaction.coordinate.latitude,currentLoaction.coordinate.longitude, currentLoaction.altitude, currentLoaction.course, currentLoaction.speed);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLocatingWithLocation:)]) {
            
            [self.delegate didFinishLocatingWithLocation:currentLoaction];
        }
    });
    
    // 反编码
    [self getCityNameWithCoordinate:CLLocationCoordinate2DMake(currentLoaction.coordinate.latitude, currentLoaction.coordinate.longitude)];
    
    // 关闭定位
    [self stopLocating];
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if ([error code] == kCLErrorDenied) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(refusedToLocateWithMessage:)]) {
                
                [self.delegate refusedToLocateWithMessage:@"App需要开启定位权限才能使用定位功能"];
            }
        });
    }else if ([error code] == kCLErrorLocationUnknown) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFailLocatingWithMessage:)]) {
                
                [self.delegate didFailLocatingWithMessage:@"无法获取位置信息"];
            }
        });
    }
}

// 自定义编码方法, 根据城市名称返回该城市的经纬度
- (void)getCoordinateWithCityName:(NSString *)cityName {
    
    [self.geocoder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"编码失败 : %@", error);
        }else {
            
            // 可能城市重名, 所以结果是数组, 这里随便取一个地方
            CLPlacemark *placeMark = [placemarks firstObject];
            NSLog(@"%@的经纬度===%f, %f", cityName, placeMark.location.coordinate.longitude, placeMark.location.coordinate.latitude);
        }
    }];
}

// 自定义反编码方法, 根据经纬度返回该城市名称
- (void)getCityNameWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"反编码失败  %@", error);
        }else {
            
            CLPlacemark *placemark = [placemarks firstObject];

//            NSLog(@"国家 : %@", placemark.country);
//            NSLog(@"省 : %@", placemark.administrativeArea);
//            NSLog(@"城市 : %@", placemark.locality);
//            NSLog(@"区 : %@", placemark.subLocality);
//            NSLog(@"位置 : %@", placemark.name);
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLocatingWithPlacemark:)]) {
                    
                    [self.delegate didFinishLocatingWithPlacemark:placemark];
                }
            });
        }
    }];
}


@end
