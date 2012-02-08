//
//  DetailViewController.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Episode;

@interface DetailViewController : UIViewController {
    
    Episode *_episode;

}

@property (strong, nonatomic) Episode *episode;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIWebView *videoView;

@end
