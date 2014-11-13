//
//  ValueTransformer.m
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import "ValueTransformer.h"
#import "TwitterConnectionManager.h"

@interface TwitterConnectionManager ()

@property (nonatomic, strong) TwitterConnectionManager *twitterConnectionManager;

@end

@implementation ValueTransformer

+ (instancetype)sharedTransformer {
    static ValueTransformer *__transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __transformer = [[self alloc] init];
    });
    return __transformer;
}

- (instancetype)init {
    if (self = [super init]) {
//        self.twitterConnectionManager = [[TwitterConnectionManager alloc] init];
    }
    return self;
}

- (void)getTweetsForLocation:(CLLocation *)location withSuccessBlock:(void (^)(NSDictionary *tweetDict))successBlock failure:(void (^)(NSError *error))failureBlock {
    
}

@end
