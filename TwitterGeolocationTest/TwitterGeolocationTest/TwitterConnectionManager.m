//
//  TwitterConnectionManager.m
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import "TwitterConnectionManager.h"

static const NSString *kTwitterConsumerKey = @"lrrwwaMcOMZ2ZYyUSWWSfxCOF";
static const NSString *kTwitterConsumerSecret = @"k8nG6Ib3dVu4MBtIRyrCyqoqi0FZVsbD4JPIxvRc37jRCN7qqh";
static const NSString *kTwitterAccessToken = @"39268717-JEGwOturZANCxByV9lT2mtYT5Tlo1zl6VO70Qs4Wn";
static const NSString *kTwitterAccessTokenSecret = @"WP8KYyyqRvW8mmaLHYvlAzda56OBzUUJAMg440nIwYTzk";

@interface TwitterConnectionManager () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation TwitterConnectionManager

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
#warning need to set headers here with API Keys
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        [config setURLCache:cache];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

@end
