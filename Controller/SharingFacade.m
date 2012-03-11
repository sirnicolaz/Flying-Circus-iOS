//
//  SharingFacade.m
//  Flying Circus Player
//
//  Created by Nicola Miotto on 3/11/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "SharingFacade.h"

#import "SHKTwitter+AutoShare.h"
#import "AppDelegate.h"

@implementation SharingFacade

+(void) shareFirstItem
{
    
}

+(void) share:(Episode*)anEpisode
{
    // Create the item to share (in this example, a url)
    SHKItem *item = [SHKItem text:@"Test http://www.flyingcircusapp.com"];
    
    // Share the item
    [SHKTwitter logout];
    [SHKTwitter shareItem:item];
}

+(void) setSharingWith:(SharingOptions)option
                active:(BOOL)flag
{
    
}

@end
