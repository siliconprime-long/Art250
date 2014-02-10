//
//  ATContactUsController.m
//  art250
//
//  Created by Winfred Raguini on 5/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATContactUsController.h"

@interface ATContactUsController ()

@end

@implementation ATContactUsController

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
    [self.navigationItem setTitle:@"Contact Us"];
	// Do any additional setup after loading the view.
    //NSString *fullURL = @"http://arttwo50.herokuapp.com/contact_us/index?layout_type=webview";
#ifdef DEBUG
    //static NSString * const kATAPIBaseURLString = @"http://gentle-journey-7944.herokuapp.com/";
    NSString *fullURL = @"http://arttwo50.herokuapp.com/contact_us/index?layout_type=webview";
#else
    NSString *fullURL = @"http://www.arttwo50.com/contact_us/index?layout_type=webview";
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
