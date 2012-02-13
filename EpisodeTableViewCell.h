//
//  EpisodeViewCell.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/9/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxTitleHeight 50
#define kRowPadding 25
#define kTitleFontSize 16
#define kSubtitleFontSize 13

@interface EpisodeTableViewCell : UITableViewCell<UIGestureRecognizerDelegate> {
    UILabel     *_durationLabel;
    UILabel     *_broadCastDateLabel;
    UILabel     *_titleLabel;
    UIImageView *_thumbImageView;
}


@property (strong, nonatomic) IBOutlet UILabel     *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel     *broadCastDateLabel;
@property (strong, nonatomic) IBOutlet UILabel     *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, getter = isWatched) BOOL      watched;


// Check if unchecked and vice-versa.
- (void)switchCheck;
- (void)setup;

@end
