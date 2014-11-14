//
//  TwitterConnectionManager.h
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterConnectionManager : NSObject

- (void)getTweetJSONForLongitude:(float)longitude andLatitude:(float)latitude withSuccess:(void (^)(NSArray *jsonArray))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
