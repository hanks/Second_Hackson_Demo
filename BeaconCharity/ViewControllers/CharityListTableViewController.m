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

@interface CharityListTableViewController ()

@property (nonatomic) NSNumber *minor;
@property (nonatomic) NSNumber *major;
@property (strong, nonatomic) NSMutableArray *charityItems;

@end

@implementation CharityListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
