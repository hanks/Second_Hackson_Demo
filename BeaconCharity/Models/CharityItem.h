//
//  Item.h
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface CharityItem : NSObject

@property (strong, nonatomic, readonly) NSString *itemName;
@property (strong, nonatomic, readonly) NSString *longDesc;
@property (strong, nonatomic, readonly) NSString *shortDesc;
@property (nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (nonatomic, readonly) NSInteger objectiveMoney;
@property (nonatomic, readonly) NSInteger rating;
@property (nonatomic, readonly) NSInteger actualMoney;
@property (nonatomic, readonly) NSString* iconName;

- (instancetype)initWithName:(NSString *)itemName
                    longDesc:(NSString *)longDesc
                   shortDesc:(NSString *)shortDesc
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
              objectiveMoney:(NSInteger)objectiveMoney
                 actualMoney:(NSInteger)actualMoney
                      rating:(NSInteger)rating
                    iconName:(NSString *)iconName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
