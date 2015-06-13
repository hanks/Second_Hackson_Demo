//
//  CharityDetailViewController.m
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "CharityDetailViewController.h"
#import "M13ProgressViewImage.h"

@interface CharityDetailViewController ()

@property (weak, nonatomic) IBOutlet M13ProgressViewImage *progressImageView;

@end

@implementation CharityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_progressImageView setProgressImage:[UIImage imageNamed:@"colorHeart"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // sleep for 0.6 sencond to pop up
            [NSThread sleepForTimeInterval:0.6];
            [_progressImageView setProgress:.75 animated:YES];
        });
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
