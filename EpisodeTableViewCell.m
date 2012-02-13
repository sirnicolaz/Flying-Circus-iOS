//
//  EpisodeViewCell.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "EpisodeTableViewCell.h"
#import "Imports.h"
#import "UIImageView+AFNetworking.h"

#define kNumberLabelViewTag 84
#define kCheckButtonTag 85

#define kEditingHorizontalOffset 35


@implementation EpisodeTableViewCell

@synthesize durationLabel       = _durationLabel;
@synthesize broadCastDateLabel  = _broadCastDateLabel;
@synthesize titleLabel          = _titleLabel;
@synthesize thumbImageView      = _thumbImageView;
@synthesize watched             = _watched;

- (void)configureTitle
{
    //[self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setNumberOfLines:1];
    
    [self.titleLabel setFont:kDefaultFontAndSize(kTitleFontSize)];
    
    [self.titleLabel setTextColor:kDefaultTextColor];
    [self.titleLabel setShadowColor:[UIColor blackColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
}

- (void)configureSubtitles
{
    // Episode duration label
    [self.durationLabel setFont:kDefaultFontAndSize(kSubtitleFontSize)];
    [self.durationLabel setTextColor:kDefaultTextColor];
    [self.durationLabel setShadowColor:[UIColor blackColor]];
    [self.durationLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    // Broadcast date label
    [self.broadCastDateLabel setFont:kDefaultFontAndSize(kSubtitleFontSize)];
    [self.broadCastDateLabel setTextColor:kDefaultTextColor];
    [self.broadCastDateLabel setShadowColor:[UIColor blackColor]];
    [self.broadCastDateLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
}


- (void)configureBackground
{
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_background"]];
    [self setBackgroundView:back];
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void)configureCheckbox
{
    UIImageView *checkboxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox-unchecked"]];
    checkboxView.tag = kCheckButtonTag;
    
    CGRect checkboxFrame = self.contentView.frame;
    checkboxFrame.size = checkboxView.frame.size;
    checkboxFrame.origin.x = -kEditingHorizontalOffset / 2 - checkboxView.frame.size.width / 2;
    checkboxFrame.origin.y = self.contentView.center.y - checkboxView.frame.size.height / 2;
    checkboxView.frame = checkboxFrame;
    
    [self.contentView addSubview:checkboxView];
}

- (void)setup
{
    [self configureBackground];
    [self configureTitle];
    [self configureSubtitles];
    [self configureCheckbox];
    [self.accessoryView setBackgroundColor:[UIColor clearColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)simulateEditing:(BOOL)editing animated:(BOOL)animated
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	if (editing)
	{
		CGRect contentFrame = self.contentView.frame;
		contentFrame.origin.x = kEditingHorizontalOffset;
		self.contentView.frame = contentFrame;
        
        CGRect accessoryFrame = self.accessoryView.frame;
        accessoryFrame.origin.x = SCREEN_WIDTH;
        self.accessoryView.frame = accessoryFrame;
        
        if ([self isWatched]) {
            UIImageView *checkboxView = (UIImageView*)[self.contentView viewWithTag:kCheckButtonTag];
            [checkboxView setImage:[UIImage imageNamed:@"checkbox-checked"]];
        }
	}
	else
	{
		CGRect contentFrame = self.contentView.frame;
		contentFrame.origin.x = 0;
		self.contentView.frame = contentFrame;
        
        CGRect accessoryFrame = self.accessoryView.frame;
        accessoryFrame.origin.x = contentFrame.origin.x + contentFrame.size.width;
        self.accessoryView.frame = accessoryFrame;
	}
    
	[UIView commitAnimations];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        for (UIView *subview in self.subviews)
        {
            NSLog(@"%@", NSStringFromClass([subview class]));
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
            {
                [subview removeFromSuperview];
            }
        }
    }
}

- (void) didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        [self simulateEditing:YES animated:YES];
    }
}
- (void) layoutSubviews {
    if(![self isEditing]){
        [super layoutSubviews];
    }
    // you can manipulate cell subviews, like self.textLabel, self.detailTextLabel...
}

- (void)prepareForReuse
{
}

#pragma mark - Actions

- (void)switchCheck
{
    if ([self isWatched]) {
        UIImageView *checkboxView = (UIImageView*)[self.contentView viewWithTag:kCheckButtonTag];
        [checkboxView setImage:[UIImage imageNamed:@"checkbox-unchecked"]];
    }
    else {
        UIImageView *checkboxView = (UIImageView*)[self.contentView viewWithTag:kCheckButtonTag];
        [checkboxView setImage:[UIImage imageNamed:@"checkbox-checked"]];
    }
    
    self.watched = ![self isWatched];
}

@end
