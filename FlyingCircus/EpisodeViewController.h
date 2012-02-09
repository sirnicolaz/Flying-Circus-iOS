//
//  DetailViewController.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Episode;
@class Part;

@interface EpisodeViewController : UIViewController {
    
    @private
    NSArray *_cachedSortedParts;
    Part    *_currentPart;
}

@property (strong, nonatomic) Episode           *episode;
@property (strong, nonatomic) Part              *currentPart;
@property (strong, nonatomic) IBOutlet UIView   *videoContainerView;
@property (strong, nonatomic) IBOutlet UILabel  *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel  *currentPartLabel;

// Move to next part
- (IBAction)previous:(id)sender;

// Move to previous part
- (IBAction)next:(id)sender;

@end
