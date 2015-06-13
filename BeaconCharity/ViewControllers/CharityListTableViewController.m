//
//  CharityListTableViewController.m
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "CharityListTableViewController.h"
#import "APIManager.h"
#import "CharityItem.h"
#import "CharityDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>

static NSString * const kUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString * const kIdentifier = @"SomeIdentifier";

@interface CharityListTableViewController ()

@property (nonatomic) NSNumber *major;
@property (strong, nonatomic) NSMutableArray *charityItems;

@end

@implementation CharityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    NSLog(@"Turning on ranging...");
    
    [self createBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Ranging turned on for region: %@.", self.beaconRegion);
    
    //////////////////////////
    self.major = [NSNumber numberWithInteger:12];;
    
    self.charityItems = [NSMutableArray array];
    
    // fetch items from server
    __weak CharityListTableViewController *weakSelf = self;
    SuccessCallback successcallback = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *aDictionary = (NSDictionary *)responseObject;
        NSMutableArray *itemArr = [NSMutableArray array];
        itemArr = (NSMutableArray *)aDictionary[@"charityItems"];
        
        for (NSDictionary *dict in itemArr) {
            [weakSelf.charityItems addObject:[[CharityItem alloc] initWithDictionary:dict]];
        }
        
        // reload data aync
        [weakSelf.tableView reloadData];
    };
    
    // call item json api
    NSString *endpoint = [NSString stringWithFormat:@"/charityitems/%@", self.major];
    [APIManager requestJSONWithEndpoint:endpoint successCallback:successcallback];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBeaconRegion {
    if (self.beaconRegion)
        return;
    
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                           identifier:kIdentifier];
    self.beaconRegion.notifyEntryStateOnDisplay= YES;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.charityItems count];
}

- (UIImage *)imageForRating:(NSInteger)rating
{
    switch (rating) {
        case 1: return [UIImage imageNamed:@"1StarSmall"];
        case 2: return [UIImage imageNamed:@"2StarsSmall"];
        case 3: return [UIImage imageNamed:@"3StarsSmall"];
        case 4: return [UIImage imageNamed:@"4StarsSmall"];
        case 5: return [UIImage imageNamed:@"5StarsSmall"];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharityCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    CharityItem *item = (CharityItem *)self.charityItems[index];
    
    // set title
    UILabel *titileLabel = (UILabel *)[cell viewWithTag:99];
    titileLabel.text = item.itemName;
    
    // set subtitl
    UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:100];
    subtitleLabel.text = item.shortDesc;
    
    // set star image
    UIImageView *ratingImageView = (UIImageView *)[cell viewWithTag:101];
    ratingImageView.image = [self imageForRating:item.rating];
    
    // set icon
    // call item image api
    __weak UITableViewCell *weakCell = cell;
    SuccessCallback successcallback = ^(AFHTTPRequestOperation *operation, id imageObject) {
        UIImageView *icon = (UIImageView *)[weakCell viewWithTag:98];
        icon.image = imageObject;
    };
    NSString *endpoint = [NSString stringWithFormat:@"/image/%@", item.iconName];
    [APIManager requestImageWithEndpoint:endpoint successCallback:successcallback];
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Assume self.view is the table view
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    CharityItem *charityItem = self.charityItems[path.row];
    [(CharityDetailViewController *)segue.destinationViewController setCharityItem:charityItem];
}

#pragma mark - CLLocationManagerDelegate

/*
 * When monitoring error
 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitoring Error");
}

/*
 * When enter region
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Found Region");
    [self sendLocalPush:@"You find me, see detail"];
    [self vibratePhone];
}

/*
 * When leave region
 */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"didExitRegion");
    [self sendLocalPush:@"leave region"];
    [self vibratePhone];
}

/*
 * During monitoring
 */
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] == 0) {
        return ;
    }
    
    // now just handle one beacon
    CLBeacon *beacon = [beacons objectAtIndex:0];
    
    // update minor and major
    self.major = beacon.major;
}

#pragma mark - Utilities

/*
 * Send local push
 */
- (void)sendLocalPush:(NSString *)msg {
    UILocalNotification *localPush = [[UILocalNotification alloc] init];
    localPush.alertBody = msg;
    localPush.soundName = @"localPush.mp3";
    localPush.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
    localPush.applicationIconBadgeNumber = 1;
    
    // send major and minor info in the local push
    NSDictionary *infoDic = @{
                              @"major": self.major,
                              };
    localPush.userInfo = infoDic;
    
    // send local push
    [[UIApplication sharedApplication] scheduleLocalNotification:localPush];
}

/*
 * Make phone vibration
 */
- (void)vibratePhone {
    // double vibration to emphasize
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            sleep(1);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            sleep(1);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    });
}

@end
