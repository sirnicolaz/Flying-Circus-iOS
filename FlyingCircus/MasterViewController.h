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

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    NSArray *_seasons;
    NSManagedObjectContext *_context;
    
    @private
    BOOL _searching;
    BOOL _letUserSelectRow;
}

@property (nonatomic, assign) IBOutlet UISearchBar *tableSearchBar;

@property (strong, nonatomic) EpisodeViewController *episodeViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
