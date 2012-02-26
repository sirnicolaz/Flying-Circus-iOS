//
//  SeasonHeaderView.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "SeasonHeaderView.h"
#import "Imports.h"

@implementation SeasonHeaderView

@synthesize title = _title;

- (id)initWithTitle:(NSString*)aTitle
{
    self = [super init];
    if(self) {
        self.title = [aTitle uppercaseString];
        
        CGRect frame = CGRectMake(0, 0, 320, kSectionHeaderHeight);
        
        // Configure background
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImageSectionHeaderBackground]];
        background.frame = frame;
        
        [self addSubview:background];
        
        // Configure title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        [titleLabel setTextColor:[UIColor redColor]];
        [titleLabel setFont:kDefaultFontAndSize(18.0)];
        [titleLabel setShadowColor:[UIColor blackColor]];
        [titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setText:self.title];
        
        [self addSubview:titleLabel];
    }
    
    return self;
}

@end
