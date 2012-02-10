//
//  EpisodeViewCell.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeViewCell.h"
#import "Constants.h"

#define kNumberLabelViewTag 84

@implementation EpisodeViewCell

@synthesize title = _title;
@synthesize number = _number;
@synthesize height = _height;

- (CGFloat)height
{
    CGSize titleSize = [self.title sizeWithFont:[UIFont fontWithName:kDefaultFont size:kTitleFontSize] 
                              constrainedToSize:CGSizeMake(240, kMaxTitleHeight) 
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    return MAX(kMaxTitleHeight + kRowPadding, titleSize.height + kRowPadding) ; // +10 => padding
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    /*
     CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:kDefaultFont size:20] constrainedToSize:CGSizeMake(240, 300) lineBreakMode:UILineBreakModeWordWrap];
    
    if (titleSize.height > kMaxTitleHeight) {
        [self.textLabel setFont:[UIFont fontWithName:kDefaultFont size:15.0]];
    }
     */
    
    [self.textLabel setText:title];
}

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    
    if ([number intValue] == -1) {
        for (UIView *view in self.imageView.subviews) {
            [view removeFromSuperview];
        }
    }
    else {
        CGRect labelFrame = CGRectMake(0, 0, 40, 37.5);
        UILabel *epNumberLabel = [[UILabel alloc] initWithFrame:labelFrame];
        epNumberLabel.tag = kNumberLabelViewTag;
        [epNumberLabel setText:[number stringValue]];
        [epNumberLabel setTextColor:[UIColor whiteColor]];
        [epNumberLabel setFont:[UIFont fontWithName:@"AlikeAngular-Regular" size:18.0]];
        [epNumberLabel setBackgroundColor:[UIColor clearColor]];
        [epNumberLabel setTextAlignment:UITextAlignmentCenter];
        
        [self.imageView addSubview:epNumberLabel];
        [self.imageView bringSubviewToFront:epNumberLabel];
    }
}

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
        [self configureTitle];
        [self configureImage];
        
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
    self.title = @"";
    self.number = [NSNumber numberWithInt:-1];
}

@end
