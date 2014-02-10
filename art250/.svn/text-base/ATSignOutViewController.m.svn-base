//
//  ATSignOutViewController.m
//  art250
//
//  Created by Winfred Raguini on 10/16/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATSignOutViewController.h"

@interface ATSignOutViewController ()

@end

@implementation ATSignOutViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signOutButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(signOutButtonSelected:)]) {
        //[self.delegate performSelector:@selector(signOutButtonSelected:) withObject:nil];
        [self.delegate performSelectorOnMainThread:@selector(signOutButtonSelected:) withObject:nil waitUntilDone:NO];
    }
}

@end
