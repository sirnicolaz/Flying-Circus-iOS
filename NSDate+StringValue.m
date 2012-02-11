//
//  NSDate+StringValue.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/11/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "NSDate+StringValue.h"

@implementation NSDate (StringValue)

- (NSString*)stringValue
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:self];
}

@end
