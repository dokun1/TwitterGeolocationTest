//
//  TwitterAnnotation.m
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/14/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import "TwitterAnnotation.h"

@implementation TwitterAnnotation

- (instancetype)initWithTweet:(Tweet *)tweet title:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinates {
    if (self = [super init]) {
        _tweet = tweet;
        _title = title;
        _coordinate = coordinates;
    }
    return self;
}

@end
