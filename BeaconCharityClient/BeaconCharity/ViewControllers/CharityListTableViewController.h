//
//  CharityListTableViewController.h
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CharityListTableViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@end
