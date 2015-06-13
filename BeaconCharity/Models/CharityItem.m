//
//  Item.m
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "CharityItem.h"

@implementation CharityItem

- (instancetype)initWithName:(NSString *)itemName
                    longDesc:(NSString *)longDesc
                   shortDesc:(NSString *)shortDesc
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
              objectiveMoney:(NSInteger)objectiveMoney
                 actualMoney:(NSInteger)actualMoney
                      rating:(NSInteger)rating
                    iconName:(NSString *)iconName
             detailImageName:(NSString *)detailImageName {
    
    self = [super init];
    
    if (self) {
        _itemName = itemName;
        _longDesc = longDesc;
        _shortDesc = shortDesc;
        _majorValue = major;
        _minorValue = major;
        _objectiveMoney = objectiveMoney;
        _actualMoney = actualMoney;
        _rating = rating;
        _iconName = iconName;
        _detailImageName = detailImageName;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    NSString *itemName = dict[@"name"];
    NSString *shortDesc = dict[@"short_desc"];
    NSString *longDesc = dict[@"long_desc"];
    NSString *iconName = dict[@"image_name"];
    NSString *detailImageName = dict[@"detail_image_name"];
    CLBeaconMajorValue majorValue = [dict[@"major"] intValue];
    CLBeaconMajorValue minorValue = [dict[@"minor"] intValue];
    NSInteger rating = [dict[@"rating"] intValue];
    NSInteger objectiveMoney = [dict[@"objective_money"] intValue];
    NSInteger actualMoney = [dict[@"actual_money"] intValue];
    
    return [self initWithName:itemName
                     longDesc:longDesc
                    shortDesc:shortDesc
                        major:majorValue
                        minor:minorValue
               objectiveMoney:objectiveMoney
                  actualMoney:actualMoney
                       rating:rating
                     iconName:iconName
              detailImageName:detailImageName
            ];
}

- (float)accomplishmentRate {
    float result = (float)self.actualMoney / (float)self.objectiveMoney;
    // round two post decimal position
    return roundf(result * 100) / 100.0;
}

@end
