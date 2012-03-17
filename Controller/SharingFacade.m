//
//  SharingFacade.m
//  Flying Circus Player
//
//  Created by Nicola Miotto on 3/11/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "SharingFacade.h"
#import "Episode.h"
#import "SHKTwitter+AutoShare.h"
#import "Constants.h"

@implementation SharingFacade

+(void) didConnectToTwitter
{
    // Create the item to share (in this example, a url)
    SHKItem *item = [SHKItem text:kStatusTwitterActivated];
    
    // Share the item
    [SHKTwitter shareItem:item];
}

+(void) share:(Episode*)anEpisode
{
    if (!JUST_SHARED) {
        
        // Prevent from flooding
        SET_JUST_SHARED(YES)
        [NSTimer timerWithTimeInterval:60.0 
                                target:self 
                              selector:@selector(timerExpired) userInfo:nil repeats:NO];
        
        // Create the item to share (in this example, a url)
        SHKItem *item = [SHKItem text:kStatusTwitterEpisodeWatch(anEpisode.title)];
        
        // Share the item
        [SHKTwitter shareItem:item];
    }
}

+(void) setSharingWith:(SharingOptions)option
                active:(BOOL)flag
{
    
}

+(void) followMe
{
    //[SHKTwitter followMe];
}

+(void) timerExpired
{
    SET_JUST_SHARED(NO)
}

@end
