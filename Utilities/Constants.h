//
//  Constants.h
//  FlyingCircus
//
//  Created by Nicola Miotto on 2/10/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#ifndef FlyingCircus_Constants_h
#define FlyingCircus_Constants_h

// Fonts
#define kDefaultFontName @"AlikeAngular-Regular"
#define kDefaultFontAndSize(x) [UIFont fontWithName:@"AlikeAngular-Regular" size:(x)]

// Text
#define kDefaultTextColor [UIColor colorWithRed:0.99 green:0.47 blue:0.0 alpha:1.0]

// Table
#define kRowHeight 60
#define kSectionHeaderHeight 38

// Images
#define kImageBackButton                    @"back_button"
#define kImageBackButtonHighlighted         @"back_button-highlighted"
#define kImageCellBackground                @"cell_background"
#define kImageEpisodeViewBackground         @"wood"
#define kImageTVButtonPrevious              @"tv_button_previous"
#define kImageTVButtonNext                  @"tv_button_next"
#define kImageTVButtonPreviousHighlighted   @"tv_button_previous-highlighted"
#define kImageTVButtonNextHighlighted       @"tv_button_next-highlighted"
#define kImageMontyPythonLogo               @"navbar_title"
#define kImageNavigationBarBackground       @"navbar_background"
#define kImageSectionHeaderBackground       @"section_header_background"
#define kImagePlay                          @"play"
#define kImageCheckboxUnchecked             @"checkbox-unchecked"
#define kImageCheckboxChecked               @"checkbox-checked"
#define kImageTVFrame                       @"television"
#define kImagePaper                         @"paper"
#define kImageSplash                        @"Default"

// User defaults
#define kTwitterSharing                     @"twitterSharing"
#define SET_TWITTER_SHARING(flag)           [[NSUserDefaults standardUserDefaults] setBool:(flag) forKey:kTwitterSharing];
#define IS_TWITTER_SHARING                  [[NSUserDefaults standardUserDefaults] boolForKey:kTwitterSharing]

// Alert messages
#define kAlertDbErrorTitle                  @"Transaction error"
#define kAlertDbErrorDescription            @"An error occured attempting to save changes"
#define kAlertConnectionErrorTitle          @"Connection error"
#define kAlertConnectionErrorDescription    @"An error occured attempting to access the Internet. Check your connection."

// Strings
#define kStatusTwitterActivated             @"Finally watching the #MontyPython 's Flying Circus everywhere for free flyingcircusplayer.com Say no more, #knowwhatahmean, Nudge nudge?"

#define kStatusTwitterEpisodeWatch(title)   @"I'm watching \"(title)\", Jolly Good! #MontyPython flyingcircusplayer.com"

// Others
#define kNSFetcherControllerCacheName       @"Cache"
#define kHTMLYouTubeEmbedding(src, w, h) [NSString stringWithFormat:@"\
                                <html>\
                                    <head>\
                                        <style type=\"text/css\">\
                                        body {\
                                        background-color: black;\
                                        color: black;\
                                        }\
                                        </style>\
                                    </head>\
                                        <body style=\"margin:0\">\
                                            <embed id=\"yt\" src=\"%@\"\
                                                type=\"application/x-shockwave-flash\" \
                                                width=\"%0.0f\" height=\"%0.0f\"\
                                                style=\"background-color:black;\">\
                                            </embed>\
                                        </body>\
                                </html>", (src), (w), (h)];

#endif
