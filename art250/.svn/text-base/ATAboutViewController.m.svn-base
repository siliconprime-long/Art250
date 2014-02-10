//
//  ATAboutViewController.m
//  art250
//
//  Created by Winfred Raguini on 5/21/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATAboutViewController.h"

@interface ATAboutViewController ()

@end

@implementation ATAboutViewController

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
    [self.navigationItem setTitle:@"About"];
	// Do any additional setup after loading the view.
#ifdef DEBUG
    //static NSString * const kATAPIBaseURLString = @"http://gentle-journey-7944.herokuapp.com/";
    NSString *fullURL = @"http://www.arttwo50.com/about/index?layout_type=webview";
    //NSString *fullURL = @"http://localhost:3000/about/index?layout_type=webview";
#else
   // NSString *fullURL = @"http://gentle-journey-7944.herokuapp.com/about/index?layout_type=webview";
    NSString *fullURL = @"http://www.arttwo50.com/about/index?layout_type=webview";
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
