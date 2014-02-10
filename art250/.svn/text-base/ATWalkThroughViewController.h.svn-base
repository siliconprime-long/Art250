//
//  ATWalkThrough1ViewController.h
//  art250
//
//  Created by Winfred Raguini on 5/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol ATWalkThroughViewControllerDelegate <NSObject>

@optional
- (void)changePageFromCurrentPage:(int)page;
@end

@interface ATWalkThroughViewController : UIViewController
@property (nonatomic,strong) IBOutlet UIImageView *artworkSplashImageView;
@property (nonatomic,strong) IBOutlet UIImageView *slideImageView;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *swipeLabel;
@property (nonatomic,strong) IBOutlet UIButton *actionButton;
@property (nonatomic,copy) NSString *titleString;
@property (nonatomic,copy) NSString *descriptionString;
@property (nonatomic,copy) NSString *slideImageViewURLString;
@property (nonatomic,copy) NSString *swipeyString;
@property (nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,copy) NSString* movieURLString;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, assign) id <ATWalkThroughViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isModal;
-(IBAction)actionButtonSelected:(id) sender;
@end
