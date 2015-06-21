//
//  CharityDetailViewController.h
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "CharityItem.h"

@interface CharityDetailViewController : UIViewController <PayPalPaymentDelegate>

@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong) CharityItem *charityItem;

@end
