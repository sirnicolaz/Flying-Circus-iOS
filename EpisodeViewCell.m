//
//  EpisodeViewCell.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeViewCell.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

#define kNumberLabelViewTag 84

@implementation EpisodeViewCell

@synthesize durationLabel       = _durationLabel;
@synthesize broadCastDateLabel  = _broadCastDateLabel;
@synthesize titleLabel          = _titleLabel;
@synthesize thumbImageView      = _thumbImageView;

- (void)configureTitle
{
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.textLabel setNumberOfLines:42];
    [self.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    
    // This is the default size. In case the title is too long,
    // it will be decreased in setTitle
    [self.textLabel setFont:[UIFont fontWithName:kDefaultFont size:kTitleFontSize]];
    
    [self.textLabel setTextColor:[UIColor colorWithRed:0.99 
                                                 green:0.47 
                                                  blue:0.0 
                                                 alpha:1.0]];
    [self.textLabel setShadowColor:[UIColor blackColor]];
    [self.textLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
}


- (void)configureBackground
{
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background"]];
    [self setBackgroundView:back];
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void)configureImage
{
    [self.imageView setImage:[UIImage imageNamed:@"ep_number_back"]];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self configureBackground];
        //[self configureTitle];
        //[self configureImage];
        //[self configureLabels];
        //self.accessoryView = [[UIView alloc] initWithFrame:self.frame];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reset
{
    [self.titleLabel setText:@""];
    [self.durationLabel setText:@""];
    [self.broadCastDateLabel setText:@""];
}

@end
