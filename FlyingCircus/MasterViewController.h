//
//  MasterViewController.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class EpisodeViewController;
@class EpisodeViewCell;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    NSArray *_seasons;
    NSManagedObjectContext *_context;
    
}

@property (nonatomic, assign) IBOutlet EpisodeViewCell *episodeViewCell;

@property (strong, nonatomic) EpisodeViewController *episodeViewController;
@property (strong, nonatomic) NSArray *seasons;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
