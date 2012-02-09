//
//  EpisodeViewCell.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeViewCell.h"

@implementation EpisodeViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background"]];
        [self setBackgroundView:back];
        [self setBackgroundColor:[UIColor blackColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setFont:[UIFont fontWithName:@"AlikeAngular-Regular" size:20.0]];
        [self.textLabel setTextColor:[UIColor colorWithRed:0.99 
                                                     green:0.47 
                                                      blue:0.0 
                                                     alpha:1.0]];
        [self.textLabel setShadowColor:[UIColor blackColor]];
        [self.textLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
