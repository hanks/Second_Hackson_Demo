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

@property (weak, nonatomic) IBOutlet UILabel *charityItemNameLabel;


@end

@implementation CharityResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set charity name twitter
    self.charityItemNameLabel.text = self.itemName;
    
    [self.progressImageView setProgressImage:[UIImage imageNamed:@"colorHeart"]];
    self.processValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)(self.accomplateRate * 100)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // sleep for 0.6 sencond to pop up
            [NSThread sleepForTimeInterval:0.6];
            [_progressImageView setProgress:self.accomplateRate animated:YES];
        });
    });
    
    // set background image
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"resultBackground"]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
