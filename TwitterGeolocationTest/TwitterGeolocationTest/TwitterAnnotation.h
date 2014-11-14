//
//  TwitterAnnotation.h
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/14/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Tweet.h"
#import <CoreLocation/CoreLocation.h>

@interface TwitterAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) Tweet *tweet;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)initWithTweet:(Tweet *)tweet title:(NSString *)title andCoordinates:(CLLocationCoordinate2D)coordinates;

@end
