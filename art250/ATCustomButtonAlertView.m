//
//  ATCustomButtonAlertView.m
//  art250
//
//  Created by Winfred Raguini on 6/29/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATCustomButtonAlertView.h"

#define LABEL_OFFSET 69.0f
#define LABEL_Y_OFFSET 65.0f
#define DEFAULT_BUTTON_START_Y 60.0f
#define DEFAULT_LABEL_HEIGHT 30.0f
#define LABEL_DEFAULT_SPACE 10.0f
#define BUTTON_DEFAULT_SPACE 10.0f
#define DEFAULT_BUTTON_HEIGHT 40.0f
#define BUTTON_OFFSET 55.0f
#define DEFAULT_SPACING_BELOW_TEXT 20.0f

@implementation ATCustomButtonAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [self setUserInteractionEnabled:YES];
    if (self.backgroundImageView == nil)
    {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bg_btn_alert.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(LABEL_OFFSET, 0.0f, LABEL_OFFSET, 0.0f)]];
        [self addSubview:self.backgroundImageView];
    }
    CGRect backgroundImageViewFrame = _backgroundImageView.frame;
    backgroundImageViewFrame.origin.x = 0.0f;
    backgroundImageViewFrame.origin.y = 0.0f;
    backgroundImageViewFrame.size.height = self.frame.size.height;
    backgroundImageViewFrame.size.width = self.frame.size.width;
    [self.backgroundImageView setFrame:backgroundImageViewFrame];
    
    
    if ([self.topLabelText length] > 0) {
        CGFloat labelHeight = (self.topLabelHeight > 0) ? self.topLabelHeight : DEFAULT_LABEL_HEIGHT;
        self.topLabelTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_OFFSET, LABEL_Y_OFFSET, self.frame.size.width - (LABEL_OFFSET * 2), labelHeight)];
        self.topLabelTextLabel.numberOfLines = 2;
        self.topLabelTextLabel.backgroundColor = [UIColor clearColor];
        self.topLabelTextLabel.text = self.topLabelText;
        self.topLabelTextLabel.textColor = [UIColor whiteColor];
        self.topLabelTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topLabelTextLabel];
    }
    
    if ([self.bottomLabelText length] > 0) {
        CGFloat labelHeight = (self.bottomLabelHeight > 0) ? self.bottomLabelHeight : DEFAULT_LABEL_HEIGHT;
        if ([self.topLabelText length] > 0) {
            self.bottomLabelTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_OFFSET, self.topLabelTextLabel.frame.origin.y + self.topLabelTextLabel.frame.size.height + LABEL_DEFAULT_SPACE, self.frame.size.width - (LABEL_OFFSET * 2), labelHeight)];
        } else {
            self.bottomLabelTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_OFFSET, LABEL_Y_OFFSET, self.frame.size.width - (LABEL_OFFSET * 2), DEFAULT_LABEL_HEIGHT)];
        }
        
        self.bottomLabelTextLabel.numberOfLines = 0;
        self.bottomLabelTextLabel.backgroundColor = [UIColor clearColor];
        self.bottomLabelTextLabel.text = self.bottomLabelText;
        self.bottomLabelTextLabel.textColor = [UIColor whiteColor];
        self.bottomLabelTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.bottomLabelTextLabel];
    }
    
    if ([self.buttonTitles count] > 0) {
        int i = 0;
        CGFloat currentMaxY;
        
        if ([self.bottomLabelText length] == 0 && [self.topLabelText length] == 0) {
            currentMaxY = DEFAULT_BUTTON_START_Y;
        } else {
            currentMaxY = MAX(self.bottomLabelTextLabel.frame.origin.y + self.bottomLabelTextLabel.frame.size.height, self.topLabelTextLabel.frame.origin.y + self.topLabelTextLabel.frame.size.height);
        }
        for (NSString *buttonTitle in self.buttonTitles) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setUserInteractionEnabled:YES];

            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:i];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_email_default.png"] forState:UIControlStateNormal];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"ProximaNova-Light-webfont" size:13.0f]];
            CGRect buttonFrame = button.frame;
            buttonFrame.size.width = self.frame.size.width - (BUTTON_OFFSET * 2);
            buttonFrame.size.height = DEFAULT_BUTTON_HEIGHT;
            buttonFrame.origin.x = BUTTON_OFFSET;
            if (i == 0) {
                buttonFrame.origin.y = currentMaxY + DEFAULT_SPACING_BELOW_TEXT;
                currentMaxY = currentMaxY + buttonFrame.size.height + DEFAULT_SPACING_BELOW_TEXT;
            } else {
                buttonFrame.origin.y = currentMaxY + BUTTON_DEFAULT_SPACE;
                currentMaxY = currentMaxY + buttonFrame.size.height + BUTTON_DEFAULT_SPACE;
            }
            
            
            [button setFrame:buttonFrame];
            [self addSubview:button];
            i++;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)buttonClicked:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if ([self.delegate respondsToSelector:@selector(customButtonAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customButtonAlertView:self clickedButtonAtIndex:button.tag];
    }
}

@end
