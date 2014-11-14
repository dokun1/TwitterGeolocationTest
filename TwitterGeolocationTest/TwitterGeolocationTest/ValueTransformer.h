//
//  ValueTransformer.h
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ValueTransformer : NSObject

+ (instancetype)sharedTransformer;

- (void)getTweetsForLocation:(CLLocation *)location withSuccessBlock:(void (^)(NSArray *tweetAnnotationArray))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
