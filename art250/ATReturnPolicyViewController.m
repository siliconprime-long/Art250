//
//  ATReturnPolicyViewController.m
//  art250
//
//  Created by Winfred Raguini on 5/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATReturnPolicyViewController.h"
#import "ATAppDelegate.h"

@interface ATReturnPolicyViewController ()

@end

@implementation ATReturnPolicyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Return Policy"];
	// Do any additional setup after loading the view.
#ifdef DEBUG
    //static NSString * const kATAPIBaseURLString = @"http://gentle-journey-7944.herokuapp.com/";
    NSString *fullURL = @"http://gentle-journey-7944.herokuapp.com/return_policy?layout_type=webview";
#else
    NSString *fullURL = @"http://www.arttwo50.com/return_policy?layout_type=webview";
#endif
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
