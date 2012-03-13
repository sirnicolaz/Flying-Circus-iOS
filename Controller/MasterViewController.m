//
//  MasterViewController.m
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/8/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "MasterViewController.h"

#import "EpisodeViewController.h"
#import "SeasonHeaderView.h"
#import "ReactiveOverlayViewController.h"
#import "SharingSettingsViewController.h"

#import "Season.h"
#import "Episode.h"

#import "Imports.h"
#import "Reachability.h"

#import "UIImageView+AFNetworking.h"
#import "UIView+SelfFromNib.h"
#import "NSDate+StringValue.h"

@interface MasterViewController ()
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void) configureSearchBar;
- (void) configureNavigationBar;
- (void) checkNetworkStatus;
- (void) animateSettingsButtonEnlight:(BOOL)flag;
- (Episode*) episodeForRowAtIndexPath:(NSIndexPath*)indexPath;
@end

@implementation MasterViewController

@synthesize episodeViewController       = _episodeViewController;
@synthesize disableOverlayView          = _disableOverlayView;
@synthesize tableSearchBar              = _tableSearchBar;
@synthesize hostReachable               = _hostReachable;
@synthesize internetReachable           = _internetReachable;
@synthesize fetchedResultsController    = __fetchedResultsController;
@synthesize managedObjectContext        = __managedObjectContext;

static bool gNotified = false;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
							
- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
	
    [self configureSearchBar];
    
    [self configureNavigationBar];
    
    // -- Fetch data
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
		[[[UIAlertView alloc] initWithTitle:kAlertDbErrorTitle 
                                    message:kAlertDbErrorDescription delegate:nil 
                          cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
	}
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Here in will appear in order to have the navigationBar already layed-out
    UIImageView *navbarTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImageMontyPythonLogo]];
    CGRect titleFrame = navbarTitle.frame;
    titleFrame.origin.y = 1;
    navbarTitle.frame = titleFrame;
    
    self.navigationItem.titleView = navbarTitle;
    
    [self checkNetworkStatus];
    
    
    if (!DID_ENTER_SETTINGS) {
        // Pulsating light button overlay
        CGRect navBarFrame = self.navigationController.navigationBar.frame;
        UIButton *leftLightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(navBarFrame.origin.x + 16, navBarFrame.origin.y + 8, 26, 26)];
        [leftLightBarButton setImage:[UIImage imageNamed:@"settings_button-light.png"] forState:UIControlStateNormal];
        [leftLightBarButton setImage:[UIImage imageNamed:@"settings_button-highlighted.png"] forState:UIControlStateHighlighted];
        [leftLightBarButton addTarget:self action:@selector(showSharingSettings) forControlEvents:UIControlEventTouchUpInside];
        leftLightBarButton.alpha = 0.0;
        leftLightBarButton.hidden = YES;
        leftLightBarButton.tag = 42;
        [self.navigationController.navigationBar addSubview:leftLightBarButton];
        [self.navigationController.navigationBar bringSubviewToFront:leftLightBarButton];
        [self animateSettingsButtonEnlight:YES];
    }
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    if (!DID_ENTER_SETTINGS) {
        UIView *enlightenedButtonView = [self.navigationController.navigationBar viewWithTag:42];
        [enlightenedButtonView removeFromSuperview];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || 
            interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown );
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // "Euristhical" approach to save one transaction with db. Yeah, really cheap.
    return [NSString stringWithFormat:@"%@ %i", 
            NSLocalizedString(@"Season", nil),
            section+1];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    SeasonHeaderView *headerView = [[SeasonHeaderView alloc] initWithTitle:title];
    return headerView;
}

// Customize the number of sections in the table view.
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EpisodeTableViewCell";
    
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [EpisodeTableViewCell selfFromNib];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleNone) {
        // Modify "watched" attribute value
        EpisodeTableViewCell *episodeCell = (EpisodeTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [episodeCell switchCheck];
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        Episode* episode = [self episodeForRowAtIndexPath:indexPath];
        episode.isWatched = [NSNumber numberWithBool:episodeCell.isWatched];
        
        NSError *error;
        if (![context save:&error]) {
            [[[UIAlertView alloc] initWithTitle:kAlertDbErrorTitle message:kAlertDbErrorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
        
        [self setEditing:NO animated:YES];
    }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [[self.tableView cellForRowAtIndexPath:indexPath] isEditing] ) {
        // The row is being edited, thus selection => check/uncheck
        return indexPath;
    }
    else if ([self isEditing]){
        // Another row is being edited. Thus, as the standard behaviour, exit editing mode
        [self setEditing:NO animated:YES]; 
        return nil;
    }
    else {
        // Normal behaviour while not editing
        return indexPath;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isEditing]) {
        // Store the new "watched" value
        [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleNone forRowAtIndexPath:indexPath];
    }
    else {
        if (!self.episodeViewController) {
            self.episodeViewController = [[EpisodeViewController alloc] initWithNibName:@"EpisodeViewController" bundle:nil];
        }
        
        self.episodeViewController.episode = [self episodeForRowAtIndexPath:indexPath];  
        [self.navigationController pushViewController:self.episodeViewController animated:YES];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Episode" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"season.number" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                                managedObjectContext:self.managedObjectContext 
                                                                                                  sectionNameKeyPath:@"season.number" 
                                                                                                           cacheName:kNSFetcherControllerCacheName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        [[[UIAlertView alloc] initWithTitle:kAlertDbErrorTitle message:kAlertDbErrorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
	}
    
    return __fetchedResultsController;
}    

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - UITableView override

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // Prevent from scrolling if editing mode enabled
    [self.tableView setScrollEnabled:!editing];
}

#pragma mark - Utiliies

- (void) configureCell:(EpisodeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Episode *episode = [self episodeForRowAtIndexPath:indexPath];;
    
    [cell.titleLabel setText:episode.title];
    [cell.durationLabel setText:episode.duration];
    [cell.broadCastDateLabel setText:[episode.broadcastDate stringValue]];
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:episode.thumbnailUrl]];
    
    cell.watched = [episode.isWatched boolValue];
}

- (void) configureSearchBar
{
    // Put the search bar out of the visible part
    CGRect bounds = self.tableView.bounds;
	bounds.origin.y = bounds.origin.y + self.tableSearchBar.bounds.size.height;
	self.tableView.bounds = bounds;
    // Do not autocorrect
    self.tableSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // To correctly handle touch during row editing
    // i.e. you can touch while editing to stop editing
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    // Black translucent overlay for searching mode
    self.disableOverlayView = [[ReactiveOverlayViewController alloc] initWithNibName:@"ReactiveOverlayViewController" bundle:[NSBundle mainBundle]];
    
    CGFloat y = self.navigationController.navigationBar.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGRect frame = CGRectMake(0, y, width, height);
    self.disableOverlayView.view.frame = frame;
    self.disableOverlayView.view.backgroundColor = [UIColor blackColor];
    
    self.disableOverlayView.target = self;
    self.disableOverlayView.action = @selector(exitSearch);
    
}

- (void) configureNavigationBar
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        // Setup navigation bar background for iOS5
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:kImageNavigationBarBackground] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        // Setup navigation bar background for iOS4
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.047 green:0.203 blue:0.070 alpha:1.0]];
    }
    
    // Add "settings" button
    CGRect leftBarButtonFrame = CGRectMake(0, 0, 49, 49);
    UIButton *lefBarButton = [[UIButton alloc] initWithFrame:leftBarButtonFrame];
    [lefBarButton setImage:[UIImage imageNamed:@"settings_button.png"] forState:UIControlStateNormal];
    [lefBarButton setImage:[UIImage imageNamed:@"settings_button-highlighted.png"] forState:UIControlStateHighlighted];
    [lefBarButton addTarget:self action:@selector(showSharingSettings) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lefBarButton];

}

- (void)animateSettingsButtonEnlight:(BOOL)flag
{
    UIView *enlightenedButtonView = [self.navigationController.navigationBar viewWithTag:42];
    
    [UIView animateWithDuration:0.5
                          delay:0.0 
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         if (flag) {
                             enlightenedButtonView.hidden = NO;
                             enlightenedButtonView.alpha = 1.0;
                         }
                         else {
                             enlightenedButtonView.alpha = 0.0;
                         }
        
                     }
                     completion:^(BOOL finished) {
                         // Pulsating button View removed
                         if ([self.navigationController.navigationBar viewWithTag:42] == nil) return;
                         
                         if (!flag) enlightenedButtonView.hidden = YES;
                         
                         if (!DID_ENTER_SETTINGS) {
                             // User entered settings, thus stop animating
                             [self animateSettingsButtonEnlight:!flag];
                         }
                         else {
                             [enlightenedButtonView removeFromSuperview];
                         }
                     }];
}

- (void) showSharingSettings
{
    SET_DID_ENTER_SETTINGS(YES);
    
    SharingSettingsViewController *sharingSettingsVC = [[SharingSettingsViewController alloc] initWithNibName:@"SharingSettingsViewController" bundle:nil];
    
    sharingSettingsVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self presentModalViewController:sharingSettingsVC animated:YES];
}

- (Episode*) episodeForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section]; 
    Episode *episode = [[sectionInfo objects] objectAtIndex:indexPath.row];
    
    return episode;
}

#pragma mark - Connection check

- (void) checkNetworkStatus
{
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCheckNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    self.hostReachable = [Reachability reachabilityWithHostName: @"www.youtube.com"];
    [self.hostReachable startNotifier];
}

- (void) didCheckNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    NetworkStatus hostStatus = [self.hostReachable currentReachabilityStatus];
    
    extern bool gNotified;
    
    if ((internetStatus == NotReachable || hostStatus == NotReachable) && !gNotified) {
        
        DLog(@"The internet is down.");
        
        [[[UIAlertView alloc] initWithTitle:kAlertConnectionErrorTitle message:kAlertConnectionErrorDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        gNotified = true;
    }
}



#pragma mark - Search logic

- (void) filterContentForSearchText:(NSString*)searchText
{
    NSString *query = searchText;
    [NSFetchedResultsController deleteCacheWithName:kNSFetcherControllerCacheName];
    
    if (query && query.length) {
        // Set a new predicate to filter out rows based on title or summary
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ or sketches contains[c] %@", query, query];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    else {
        [self.fetchedResultsController.fetchRequest setPredicate:nil];
    }
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Handle error
        exit(-1);
    }
    
    [self.tableView reloadData];
}

- (void) searchBar:(UISearchBar *)searchBar activate:(BOOL) active{	
    
    if (!active) {
        [searchBar resignFirstResponder];
        [self.disableOverlayView.view removeFromSuperview];
    } else {
        self.disableOverlayView.view.alpha = 0;
        [self.tableView insertSubview:self.disableOverlayView.view aboveSubview:self.parentViewController.view];
        
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        self.disableOverlayView.view.alpha = 0.6;
        [UIView commitAnimations];
		
    }
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self searchBar:searchBar activate:YES];
}

- (void) exitSearch {
    [self searchBar:self.tableSearchBar activate:NO];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContentForSearchText:searchBar.text];
    [self searchBar:searchBar activate:NO];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText];
}

@end
