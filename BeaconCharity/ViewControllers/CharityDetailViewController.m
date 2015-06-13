//
//  CharityDetailViewController.m
//  BeaconCharity
//
//  Created by hanks on 6/13/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "CharityDetailViewController.h"
#import "M13ProgressViewImage.h"
#import <QuartzCore/QuartzCore.h>
#import "CharityResultViewController.h"
#import "APIManager.h"

@interface CharityDetailViewController ()

@property (weak, nonatomic) IBOutlet M13ProgressViewImage *progressImageView;
@property (weak, nonatomic) IBOutlet UILabel *processValueLabel;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;

@property (weak, nonatomic) IBOutlet UIImageView *charityDetailImageView;
@property (weak, nonatomic) IBOutlet UITextView *charityDetailDescTextView;

@end

@implementation CharityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.progressImageView setProgressImage:[UIImage imageNamed:@"colorHeart"]];
    self.processValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)([self.charityItem accomplishmentRate] * 100)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // sleep for 0.6 sencond to pop up
            [NSThread sleepForTimeInterval:0.6];
            [_progressImageView setProgress:[self.charityItem accomplishmentRate] animated:YES];
        });
    });
    
    // update detail image
    // call item image api
    __weak CharityDetailViewController *weakSelf = self;
    SuccessCallback successcallback = ^(AFHTTPRequestOperation *operation, id imageObject) {
        weakSelf.charityDetailImageView.image = imageObject;
    };
    NSString *endpoint = [NSString stringWithFormat:@"/image/%@", self.charityItem.detailImageName];
    [APIManager requestImageWithEndpoint:endpoint successCallback:successcallback];

    
    // update long description
    [self.charityDetailDescTextView setText:self.charityItem.longDesc];
    
    // set up paypal configuration
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // set paypal language
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    // set address option
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pay {
    // Remove our last completed payment, just for demo purposes.
    // self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    // fake to 200$
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"100"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = self.charityItem.shortDesc;
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    
    // access api to update database
    NSString *endpoint = [NSString stringWithFormat:@"/charityitem/%zd/%zd", self.charityItem.majorValue, self.charityItem.minorValue];
    
    NSDictionary *params = @{@"donation": @"200"};
    
    [APIManager requestPostWithEndpoint:endpoint
                             dictionary:params
                        successCallback:nil];
    
    // return to detail view
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // jump to result view
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CharityResultViewController *resultVC = [storyBoard instantiateViewControllerWithIdentifier:@"CharityResultViewController"];
    [self presentViewController:resultVC animated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

@end
