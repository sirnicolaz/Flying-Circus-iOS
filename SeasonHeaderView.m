//
//  SeasonHeaderView.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "SeasonHeaderView.h"

@implementation SeasonHeaderView

@synthesize title = _title;

- (id)initWithTitle:(NSString*)aTitle
{
    self = [super init];
    if(self) {
        self.title = aTitle;
        
        CGRect labelFrame = CGRectMake(0, 0, 320, 50);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [titleLabel setTextColor:[UIColor redColor]];
        [titleLabel setFont:[UIFont fontWithName:@"Ewert-Regular" size:25.0]];
        [titleLabel setBackgroundColor:[UIColor blackColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setText:self.title];
        
        [self addSubview:titleLabel];
    }
    
    return self;
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
