//
//  ATBlogViewController.m
//  art250
//
//  Created by Winfred Raguini on 8/24/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATBlogViewController.h"

@interface ATBlogViewController ()

@end

@implementation ATBlogViewController

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
    [self.navigationItem setTitle:@"Blog"];
	// Do any additional setup after loading the view.

    NSString *fullURL = @"http://blog.arttwo50.com/mobile";
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
