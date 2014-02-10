//
//  ATArtworkButtonsViewController.m
//  art250
//
//  Created by Winfred Raguini on 4/14/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATArtworkButtonsViewController.h"
#import "ATArtObject.h"
#import "ATArtManager.h"

#define ARTWORK_BUTTON_CONTAINER_Y 183.0f

@interface ATArtworkButtonsViewController ()

@end

@implementation ATArtworkButtonsViewController

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
	// Do any additional setup after loading the view.
    [self configureButtonViews];
}

- (CGFloat)artworkButtonContainerY
{
    return 183.0f;
}

- (void)configureButtonViews
{
    self.selectedPaintingArray = [[NSMutableArray alloc] init];
    
    self.artworkButtonContainerView = [[UIView alloc] initWithFrame:CGRectMake(28.0f, [self artworkButtonContainerY], 505.0f, 423.0f)];
    
    self.artworkButton1 = [[ATArtworkButtonView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 210.0f)];
    [self.artworkButtonContainerView addSubview:self.artworkButton1];
    self.artworkButton1.tag = 1;
    self.artworkButton1.delegate = self;
    
    self.artworkButton2 = [[ATArtworkButtonView alloc] initWithFrame:CGRectMake(253.0f, 0.0f, 250.0f, 210.0f)];
    [self.artworkButtonContainerView addSubview:self.artworkButton2];
    self.artworkButton2.tag = 2;
    self.artworkButton2.delegate = self;
    
    self.artworkButton3 = [[ATArtworkButtonView alloc] initWithFrame:CGRectMake(0.0f, 213.0f, 250.0f, 210.0f)];
    [self.artworkButtonContainerView addSubview:self.artworkButton3];
    self.artworkButton3.tag = 3;
    self.artworkButton3.delegate = self;
    
    self.artworkButton4 = [[ATArtworkButtonView alloc] initWithFrame:CGRectMake(253.0f, 213.0f, 250.0f, 210.0f)];
    [self.artworkButtonContainerView addSubview:self.artworkButton4];
    self.artworkButton4.tag = 4;
    self.artworkButton4.delegate = self;
    
    
    self.paintingBtnArray = [[NSArray alloc] initWithObjects:self.artworkButton1, self.artworkButton2, self.artworkButton3, self.artworkButton4, nil];
    
    [self.view addSubview:self.artworkButtonContainerView];
    
    int artObjectEnumerator = 0;
    
    for (ATArtObject *artObject in [[ATArtManager sharedManager] collectionArray]) {
        artObjectEnumerator = artObjectEnumerator + 1;
        switch (artObjectEnumerator) {
            case 1:
                self.artworkButton1.artObject = artObject;
                break;
            case 2:
                self.artworkButton2.artObject = artObject;
                break;
            case 3:
                self.artworkButton3.artObject = artObject;
                break;
            default:
                self.artworkButton4.artObject = artObject;
                break;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
