//
//  SharingFacade.h
//  Flying Circus Player
//
//  Created by Nicola Miotto on 3/11/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Episode;

typedef enum {
    TwitterSharing,
    FacebookStaring
} SharingOptions;

@interface SharingFacade : NSObject

// Like: "I've started using blab bla"
+(void) didConnectToTwitter;

+(void) share:(Episode*)anEpisode;

+(void) setSharingWith:(SharingOptions)option
                active:(BOOL)flag;
@end
