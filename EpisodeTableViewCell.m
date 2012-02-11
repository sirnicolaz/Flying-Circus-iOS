//
//  EpisodeViewCell.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeTableViewCell.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

#define kNumberLabelViewTag 84

@implementation EpisodeTableViewCell

@synthesize durationLabel       = _durationLabel;
@synthesize broadCastDateLabel  = _broadCastDateLabel;
@synthesize titleLabel          = _titleLabel;
@synthesize thumbImageView      = _thumbImageView;

- (void)configureTitle
{
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setNumberOfLines:1];
    
    [self.titleLabel setFont:[UIFont fontWithName:kDefaultFont size:kTitleFontSize]];
    
    [self.titleLabel setTextColor:kDefaultTextColor];
    [self.titleLabel setShadowColor:[UIColor blackColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
}

- (void)configureSubtitles
{
    // Episode duration label
    [self.durationLabel setFont:[UIFont fontWithName:kDefaultFont size:kSubtitleFontSize]];
    [self.durationLabel setTextColor:kDefaultTextColor];
    [self.durationLabel setShadowColor:[UIColor blackColor]];
    [self.durationLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    // Broadcast date label
    [self.broadCastDateLabel setFont:[UIFont fontWithName:kDefaultFont size:kSubtitleFontSize]];
    [self.broadCastDateLabel setTextColor:kDefaultTextColor];
    [self.broadCastDateLabel setShadowColor:[UIColor blackColor]];
    [self.broadCastDateLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
}


- (void)configureBackground
{
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background"]];
    [self setBackgroundView:back];
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void)setup
{
    [self configureBackground];
    [self configureTitle];
    [self configureSubtitles];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [self.titleLabel setText:@""];
    [self.durationLabel setText:@""];
    [self.broadCastDateLabel setText:@""];
}


@end
