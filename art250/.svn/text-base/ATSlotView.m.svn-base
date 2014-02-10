//
//  ATSlotView.m
//  art250
//
//  Created by Winfred Raguini on 3/27/13.
//  Copyright (c) 2013 Art250. All rights reserved.
//

#import "ATSlotView.h"
#import "ATArtObject.h"
#import "ATArtManager.h"
#import "ATAPIClient.h"

#define OFFSET 5.0f
#define SAVED_OBJECT_IN_COLLECTION_KEY @"slottedArtObject%d"

@interface ATSlotView ()
@property (nonatomic, strong) UIImageView *soldImageView;
- (void)displayActionButtons;
- (void)hideActionButtons;
- (void)cancelButtonSelected:(id)sender;
- (void)deleteButtonSelected:(id)sender;
- (NSString*)savedArtObjectKey;
- (void)displaySavedCollectionObject;
- (void)updateStatus:(int) artworkId;
@end

@implementation ATSlotView
@synthesize artObject = _artObject;

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        // Initialization code
        self.defaultImage = [UIImage imageNamed:@"collection_spot.png"];
        
//        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
////        [longPressRecognizer setCancelsTouchesInView:NO];
//        [longPressRecognizer setMinimumPressDuration:0.3];
//        [self addGestureRecognizer:longPressRecognizer];
//
        self.soldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sold_in_collection.png"]];
        CGRect soldDotViewFrame = self.soldImageView.frame;
        soldDotViewFrame.origin.y = self.frame.size.height - self.soldImageView.frame.size.height;
        soldDotViewFrame.origin.x = self.frame.size.width - self.soldImageView.frame.size.width;
        [self.soldImageView setFrame:soldDotViewFrame];
        [self addSubview:self.soldImageView];
        [self.soldImageView setHidden:YES];
        
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panningDetected:)];
        [self addGestureRecognizer:panRecognizer];
        
        [self setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}
//
//- (void)longPressDetected:(UILongPressGestureRecognizer*)recognizer
//{
//    if (self.artObject) {
//        if ([self.delegate respondsToSelector:@selector(slotView:didLongPressWithUserInfo:)]) {
//            if (self.artObject != nil) {
//                //            [self displayActionButtons];
//                //NSLog(@"Long press detected with artObject");
//            } else {
//                //NSLog(@"Long press detected without artObject");
//            }
//            NSDictionary *slotViewDict = [[NSDictionary alloc] initWithObjectsAndKeys:recognizer,SLOTVIEW_RECOGNIZER_KEY, self.artObject, SLOTVIEW_ARTOBJECT_KEY, nil];
//            
//            [self.delegate slotView:self didLongPressWithUserInfo:slotViewDict];
//        }
//    }
//    
//}


- (void)panningDetected:(UIPanGestureRecognizer*)recognizer
{
    if (self.artObject) {
        if ([self.delegate respondsToSelector:@selector(slotView:didPanWithUserInfo:)]) {
            NSDictionary *slotViewDict = [[NSDictionary alloc] initWithObjectsAndKeys:recognizer,SLOTVIEW_RECOGNIZER_KEY, self.artObject, SLOTVIEW_ARTOBJECT_KEY, nil];
            
            [self.delegate slotView:self didPanWithUserInfo:slotViewDict];
        }
    }
    
}

- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    if (self.artObject) {
        //NSLog(@"tapDetected in slotView");
        if ([self.delegate respondsToSelector:@selector(tapDetected:)]) {
            [self.delegate performSelector:@selector(tapDetected:) withObject:recognizer];
        }
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.artObject,@"artObject", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidTapOnArtObjectInCollection object:nil userInfo:dict];
    }
}

- (void)setArtObject:(Artwork *)artObject
{
    _artObject = artObject;
    self.image = [_artObject croppedImage];
    
    //Save the object
    
    //_artObject.slotIndex = [NSNumber numberWithInt:self.tag];
    _artObject.inCollection = [NSNumber numberWithBool:YES];
    
    NSManagedObjectContext *managedObjCtx = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    NSError *executeError = nil;
    if(![managedObjCtx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    NSUInteger count = [managedObjCtx countForEntityForName:@"Artwork" predicate:nil error:nil];
    
}

- (NSString*)savedArtObjectKey
{
    return [NSString stringWithFormat:SAVED_OBJECT_IN_COLLECTION_KEY,self.tag];
}

- (void)displaySavedCollectionObject
{
    NSError *error;
    
    NSManagedObjectContext *ctx = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Artwork" inManagedObjectContext:ctx];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"slotIndex == %d", self.tag];
    [request setPredicate:predicate];
    
    NSArray *array = [ctx executeFetchRequest:request error:&error];
    if (array == nil)
    {
        
        // Deal with error...
    } else {
        if ([array count] > 0) {
            Artwork *artwork = [array objectAtIndex:0];
            //Just testing
            artwork.delegate = self;
            if (artwork) {
                _artObject = artwork;
                self.image = [artwork croppedImage];

                [artwork updateStatus];
            }
        }
    }

}


- (void)didCompleteUpdate:(ATArtObject*)artObject
{
    [self updateSoldDisplay];
}

- (void)updateSoldDisplay
{
    if (self.artObject && [self.artObject sold]) {
        [self.soldImageView setHidden:NO];
    } else {
        [self.soldImageView setHidden:YES];
    }
}


- (void)displayActionButtons
{
    self.cancelButton.hidden = NO;
    self.deleteButton.hidden = NO;
}

- (void)hideActionButtons
{
    self.cancelButton.hidden = YES;
    self.deleteButton.hidden = YES;
}

- (void)cancelButtonSelected:(id)sender
{
    [self hideActionButtons];
}

- (void)deleteButtonSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(artObjectRemovedFromCollection:)]) {
        [self.delegate performSelector:@selector(artObjectRemovedFromCollection:) withObject:self.artObject];
    }
    [self hideActionButtons];
}

- (void)reset
{
    self.image = self.defaultImage;
    
    self.artObject.inCollection = NO;
    
    NSManagedObjectContext *managedObjCtx = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    NSError *executeError = nil;
    if(![managedObjCtx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
    NSUInteger count = [managedObjCtx countForEntityForName:@"Artwork" predicate:nil error:nil];
    
    self.artObject = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
