//
//  ValueTransformer.m
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import "ValueTransformer.h"
#import "TwitterConnectionManager.h"
#import "Tweet.h"
#import "TwitterAnnotation.h"

@interface ValueTransformer ()

@property (nonatomic, strong) TwitterConnectionManager *twitterManager;

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
        self.twitterManager = [[TwitterConnectionManager alloc] init];
    }
    return self;
}

- (void)getTweetsForLocation:(CLLocation *)location withSuccessBlock:(void (^)(NSArray *tweetAnnotationArray))successBlock failure:(void (^)(NSError *error))failureBlock {
    [self.twitterManager getTweetJSONForLongitude:location.coordinate.longitude andLatitude:location.coordinate.latitude withSuccess:^(NSArray *jsonArray) {
        NSMutableArray *annotationArray = [NSMutableArray array];
        [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *jsonDict, NSUInteger idx, BOOL *stop) {
            Tweet *tweet = [[Tweet alloc] init];
            tweet.username = jsonDict[@"user"][@"name"];
            tweet.text = jsonDict[@"text"];
            tweet.imageURL = jsonDict[@"user"][@"profile_image_url"];
            tweet.timestamp = jsonDict[@"created_at"];
            NSString *coordinates = jsonDict[@"coordinates"];
            NSArray *separated = [coordinates componentsSeparatedByString:@","];
            double longitude = [separated[0] doubleValue];
            double latitude = [separated[1] doubleValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            TwitterAnnotation *annotation = [[TwitterAnnotation alloc] initWithTweet:tweet title:tweet.username andCoordinates:coordinate];
            [annotationArray addObject:annotation];
        }];
        successBlock(annotationArray);
    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

@end
