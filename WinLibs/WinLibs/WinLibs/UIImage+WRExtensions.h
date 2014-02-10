//
//  UIImage+WRExtensions.h
//  WinLibs
//
//  Created by Winfred Raguini on 9/11/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (WRExtensions)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)croppedImageWithRect:(CGRect)croppedRect;
- (UIColor*)averageColor;
- (NSArray*)averageColorArray;
- (UIColor *)mergedColor;
@end
