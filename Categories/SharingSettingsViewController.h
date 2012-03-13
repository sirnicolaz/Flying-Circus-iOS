//
//  SharingSettingsViewController.h
//  Flying Circus Player
//
//  Created by Nicola Miotto on 3/11/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"

@interface SharingSettingsViewController : UIViewController

@property (nonatomic, retain) IBOutlet DCRoundSwitch *twitterSharingSwitcher;
@property (nonatomic, retain) IBOutlet UIImageView   *background;

@end
