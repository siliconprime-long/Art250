//
//  UIColor+WRExtensions.h
//  art250
//
//  Created by Winfred Raguini on 12/30/12.
//  Copyright (c) 2012 Art250. All rights reserved.
//

#import <UIKit/UIKit.h>

static void RGB2HSL(float r, float g, float b, float* outH, float* outS, float* outL)
{
    //r = r/255.0f;
    //g = g/255.0f;
    //b = b/255.0f;
    
    
    float h,s, l, v, m, vm, r2, g2, b2;
    
    h = 0;
    s = 0;
    l = 0;
    
    v = MAX(r, g);
    v = MAX(v, b);
    m = MIN(r, g);
    m = MIN(m, b);
    
    l = (m+v)/2.0f;
    
    if (l <= 0.0){
        if(outH)
			*outH = h;
		if(outS)
			*outS = s;
		if(outL)
			*outL = l;
        return;
    }
    
    vm = v - m;
    s = vm;
    
    if (s > 0.0f){
        s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
    }else{
        if(outH)
			*outH = h;
		if(outS)
			*outS = s;
		if(outL)
			*outL = l;
        return;
    }
    
    r2 = (v - r)/vm;
    g2 = (v - g)/vm;
    b2 = (v - b)/vm;
    
    if (r == v){
        h = (g == m ? 5.0f + b2 : 1.0f - g2);
    }else if (g == v){
        h = (b == m ? 1.0f + r2 : 3.0 - b2);
    }else{
        h = (r == m ? 3.0f + g2 : 5.0f - r2);
    }
    
    h/=6.0f;
    
    if(outH)
        *outH = h;
    if(outS)
        *outS = s;
    if(outL)
        *outL = l;
    
}


@interface UIColor (WRExtensions)
- (UIColor*)complementaryColor;
- (NSString *) uiColorToHexString;
@end
