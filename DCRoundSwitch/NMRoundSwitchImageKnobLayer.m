//
//  NMRoundSwitchImageKnobLayer.m
//  Flying Circus Player
//
//  Created by Nicola Miotto on 3/12/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "NMRoundSwitchImageKnobLayer.h"

@implementation NMRoundSwitchImageKnobLayer

@synthesize knobImage;

- (void)drawInContext:(CGContextRef)context
{
    if (self.knobImage == nil) {
        [super drawInContext:context];
    }
    else {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGRect knobRect = CGRectInset(self.bounds, 0, 0);
        
        // Draw image on knob place
        CGContextDrawImage(context, knobRect, self.knobImage.CGImage);
        
        CGColorSpaceRelease(colorSpace);
    }
}

@end
