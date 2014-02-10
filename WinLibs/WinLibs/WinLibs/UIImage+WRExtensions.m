//
//  UIImage+WRExtensions.m
//  WinLibs
//
//  Created by Winfred Raguini on 9/11/12.
//
//

#import "UIImage+WRExtensions.h"
#import "UIColor+WRExtensions.h"

@implementation UIImage (WRExtensions)

#pragma mark -
#pragma mark Scale and crop image

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        //NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)croppedImageWithRect:(CGRect)croppedRect
{
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], croppedRect);
    
    // Create new cropped UIImage
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIColor*)averageColor
{
//    int count = 10000;
//    UIImage *customPixelImage = [self imageByScalingAndCroppingForSize:CGSizeMake(90.0f, 90.0f)];
//    
//
//    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
//    
//    // First get the image into your data buffer
//    CGImageRef imageRef = [customPixelImage CGImage];
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    CGColorSpaceRelease(colorSpace);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
//    CGContextRelease(context);
//    
//    // Now your rawData contains the image data in the RGBA8888 pixel format.
//    int byteIndex = (bytesPerRow * 1) + 1 * bytesPerPixel;
//    for (int ii = 0 ; ii < count ; ++ii)
//    {
//        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
//        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
//        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
//        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
//        byteIndex += 4;
//        
//        //NSLog(@"red is %1.2f", red);
//        //NSLog(@"green is %1.2f", green);
//        //NSLog(@"blue is %1.2f", blue);
//        //NSLog(@"alpha is %1.2f", alpha);
//        
//        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
//        [result addObject:acolor];
//    }
//    //NSLog(@"count array %@", result);
//    
//    free(rawData);
//    
//    return (UIColor*)[result objectAtIndex:0];
    return [UIColor redColor];
}



- (NSArray*)averageColorArray
{
    int count = 10000;
    UIImage *onePixelImage = [self imageByScalingAndCroppingForSize:CGSizeMake(100.0f, 100.0f)];
    
//    UIImageWriteToSavedPhotosAlbum(onePixelImage,
//                                   self, // send the message to 'self' when calling the callback
//                                   nil, // the selector to tell the method to call on completion
//                                   NULL);
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    NSMutableDictionary *colorDictionary = [[NSMutableDictionary alloc] init];
    
    // First get the image into the data buffer
    CGImageRef imageRef = [onePixelImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (bytesPerRow * 1) + 1 * bytesPerPixel;
    NSString *colorKey;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += 4;
        
//        float hue, saturation, luminosity;
        
//        RGB2HSL(red, green, blue, &hue, &saturation, &luminosity);
        
        
//        //NSLog(@"red is %1.2f", red);
//        //NSLog(@"green is %1.2f", green);
//        //NSLog(@"blue is %1.2f", blue);
        
//        //NSLog(@"alpha is %1.2f", alpha);
        
        colorKey = [NSString stringWithFormat:@"%1.3f,%1.3f,%1.3f,%1.3f", red, green, blue, alpha];
        
        if ([colorDictionary objectForKey:colorKey]) {
            NSNumber *numberOfColors = [NSNumber numberWithInt:[[colorDictionary objectForKey:colorKey] intValue] + 1];
            [colorDictionary setObject:numberOfColors forKey:colorKey];
        } else {
            [colorDictionary setObject:[NSNumber numberWithInt:1] forKey:colorKey];
        }
    }
//    //NSLog(@"color dictionary %@", colorDictionary);
    
//    NSArray *sortedColorArray = [colorDictionary keysSortedByValueUsingSelector:@selector(compare:)];
    
//    //NSLog(@"sortedColorArray %@", sortedColorArray);
    
    CGFloat red = 0, green = 0, blue = 0;
    for (NSString *rgbColor in [colorDictionary allKeys]) {
        NSArray *rgbArray = [rgbColor componentsSeparatedByString:@","];
        red = [[rgbArray objectAtIndex:0] floatValue];
        green = [[rgbArray objectAtIndex:1] floatValue];
        blue = [[rgbArray objectAtIndex:2] floatValue];
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    //NSLog(@"result colors %d", [result count]);
    
    return result;
}


//Taken from stackoverflow http://stackoverflow.com/questions/12147779/how-do-i-release-a-cgimageref-in-ios/12148136#12148136
- (UIColor *)mergedColor
{
	CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
	uint8_t *data = CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
									 green:data[1] / 255.0f
									  blue:data[0] / 255.0f
									 alpha:1];
	UIGraphicsEndImageContext();
	return color;
}



@end
