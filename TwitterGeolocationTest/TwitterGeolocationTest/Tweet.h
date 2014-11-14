//
//  Tweet.h
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/14/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSDate   *timestamp;

@end
