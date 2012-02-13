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

@class EpisodeViewController;
@class ReactiveOverlayViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    NSArray *_seasons;
    NSManagedObjectContext *_context;
}

// To handle black translucent view over tableView while in search mode
@property (strong, nonatomic) IBOutlet ReactiveOverlayViewController    *disableOverlayView;
@property (nonatomic, assign) IBOutlet UISearchBar                      *tableSearchBar;

@property (strong, nonatomic) EpisodeViewController         *episodeViewController;
@property (strong, nonatomic) NSFetchedResultsController    *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext        *managedObjectContext;

@end
