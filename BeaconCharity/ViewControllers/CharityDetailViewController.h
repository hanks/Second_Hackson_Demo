//
//  CharityDetailViewController.h
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface CharityDetailViewController : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;

@end
