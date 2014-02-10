//
//  ATWebViewController.h
//  art250
//
//  Created by Winfred Raguini on 4/1/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATWebViewController.h"

@interface ATWebViewController ()

@end

@implementation ATWebViewController

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
    // Do any additional setup after loading the view from its nib.
    self.webView.frame = self.view.frame;
    [self.webView setDelegate:self];
//    http://www.arttwo50.com/about/index
    NSString *fullURL = @"http://arttwo50.herokuapp.com/privacy/index?layout_type=webview";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
 
}

- (void)viewWillAppear:(BOOL)animated
{
    self.preferredContentSize = SETTINGS_POPOVER_SIZE;
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinnyView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinnyView stopAnimating];
}

@end
