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

@interface EpisodeViewCell : UITableViewCell {
    NSString *_title;
    NSNumber *_number;
}

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *number;
@property (readonly, nonatomic) CGFloat height;

- (void)reset;

@end
