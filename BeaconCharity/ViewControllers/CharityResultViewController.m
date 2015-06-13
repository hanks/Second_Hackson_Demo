//
//  CharityResultViewController.m
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "CharityResultViewController.h"
#import "M13ProgressViewImage.h"


@interface CharityResultViewController ()

@property (weak, nonatomic) IBOutlet M13ProgressViewImage *progressImageView;
@property (weak, nonatomic) IBOutlet UILabel *processValueLabel;

@end

@implementation CharityResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.progressImageView setProgressImage:[UIImage imageNamed:@"colorHeart"]];
    self.processValueLabel.text = @"83%";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // sleep for 0.6 sencond to pop up
            [NSThread sleepForTimeInterval:0.6];
            [_progressImageView setProgress:.83 animated:YES];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
