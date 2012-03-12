//
//  MasterViewController.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EpisodeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@class EpisodeViewController;
@class ReactiveOverlayViewController;
@class Reachability;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// To handle black translucent view over tableView while in search mode
@property (strong, nonatomic) IBOutlet ReactiveOverlayViewController    *disableOverlayView;

@property (assign, nonatomic) IBOutlet UISearchBar                      *tableSearchBar;

@property (strong, nonatomic) EpisodeViewController         *episodeViewController;
@property (strong, nonatomic) NSFetchedResultsController    *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext        *managedObjectContext;

@property (strong, nonatomic) Reachability  *internetReachable;
@property (strong, nonatomic) Reachability  *hostReachable;


-(void) didCheckNetworkStatus:(NSNotification *)notice;

@end
