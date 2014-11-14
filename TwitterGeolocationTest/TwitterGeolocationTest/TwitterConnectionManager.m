//
//  TwitterConnectionManager.m
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import "TwitterConnectionManager.h"
#import <Social/Social.h>

static const NSString *kTwitterConsumerKey = @"F6KBmGsEX3JjkLiJTZULaV4xp";
static const NSString *kTwitterConsumerSecret = @"kYS7QuLj9GzwQmapwbLLRacmVDR1Dvak62q6yIZ2R8J9NH45Bq";
static const NSString *kTwitterAccessToken = @"39268717-ZHuaTpgdH0re9iF0aAlu0KsTAiagpFQWRNB3BzMTi";
static const NSString *kTwitterAccessTokenSecret = @"WP8KYyyqRvW8mmaLHYvlAzda56OBzUUJAMg440nIwYTzk";

static NSString *kTwitterAPIBaseURL = @"https://api.twitter.com/";
static NSString *kTwitterOAuthURL = @"https://api.twitter.com/oauth2/token";

static const NSString *kAccessTokenJSONKey = @"access_token";

static NSString *kHTTPMethodGet = @"GET";
static NSString *kHTTPMethodPost = @"POST";
static NSString *kHTTPMethodPut = @"PUT";
static NSString *kHTTPMethodDelete = @"DELETE";

static NSString *kBearerTokenCache = @"cacheBearerToken";

static NSString *kTwitterSearchKeyQuery = @"q";
static NSString *kTwitterSearchKeyGeocode = @"geocode";
static NSString *kTwitterSearchKeyResultType = @"result_type";
static NSString *kTwitterSearchKeyCount = @"count";

static NSString *kTwitterSearchPath = @"1.1/search/tweets.json";


@interface TwitterConnectionManager () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, setter = setBearerToken:) NSString *authBearerToken;
@property (nonatomic, strong) NSDate *latestPollDate;
@property (nonatomic, strong, setter = setLatestTweets:) NSMutableArray *latestTweets;

@end

@implementation TwitterConnectionManager

- (instancetype)init {
    if (self = [super init]) {
        [self getOAuthBearerTokenWithSuccess:^(NSString *bearerToken) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                              diskCapacity:50 * 1024 * 1024
                                                                  diskPath:nil];
            [config setHTTPAdditionalHeaders:@{@"Authorization":bearerToken}];
            [config setURLCache:cache];
            _session = [NSURLSession sessionWithConfiguration:config];
        } failure:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Twitter Error" message:@"Could not authenticate Twitter API, please contact your local friendly developer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }
    return self;
}

#pragma mark - Setter Override Methods

- (void)setBearerToken:(NSString *)authBearerToken {
    _authBearerToken = authBearerToken;
    [[NSUserDefaults standardUserDefaults] setObject:authBearerToken forKey:kBearerTokenCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLatestTweets:(NSMutableArray *)latestTweets {
    _latestTweets = latestTweets;
#warning This is where I would sort through the tweets to a) keep the count at 100 and b) keep the 100 tweets always at their most recent
}

- (void)getTweetJSONForLongitude:(float)longitude andLatitude:(float)latitude withSuccess:(void (^)(NSArray *jsonArray))successBlock failure:(void (^)(NSError *error))failureBlock {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kTwitterAPIBaseURL, kTwitterSearchPath]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:kHTTPMethodGet];
    
    NSDictionary *parameters = @{kTwitterSearchKeyQuery:@"",
                                 kTwitterSearchKeyGeocode:[NSString stringWithFormat:@"%f,%f,1mi", latitude, longitude],
                                 kTwitterSearchKeyResultType:@"recent",
                                 kTwitterSearchKeyCount:@(100)};
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL]];
    
    self.latestPollDate = [NSDate date];
    
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSError *error;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error) {
                self.latestTweets = [responseDict[@"statuses"] mutableCopy];
                successBlock(self.latestTweets);
            } else {
                if (!self.latestTweets) {
                    failureBlock(error);
                } else {
                    successBlock(self.latestTweets);
                }
            }
        } else {
            if (!self.latestTweets) {
                failureBlock(error);
            } else {
                successBlock(self.latestTweets);
            }
        }
    }];
    [task resume];
}

#pragma mark - Private Methods

- (void)getOAuthBearerTokenWithSuccess:(void (^)(NSString *bearerToken))successBlock failure:(void (^)(NSError *error))failureBlock {
    if (self.authBearerToken) {
        successBlock(self.authBearerToken);
        return;
    }
    NSURL *url = [NSURL URLWithString:(NSString *)kTwitterOAuthURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *tokenCredentials = [NSString stringWithFormat:@"%@:%@", kTwitterConsumerKey, kTwitterConsumerSecret];
    NSData *tokenData = [tokenCredentials dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64TokenString = [tokenData base64EncodedStringWithOptions:0];
    
    request.HTTPMethod = kHTTPMethodPost;
    [request addValue:[NSString stringWithFormat:@"Basic %@", base64TokenString] forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"grant_type":@"client_credentials"} options:0 error:NULL];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            NSError *error;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error) {
                self.authBearerToken = responseDict[kAccessTokenJSONKey];
                successBlock(self.authBearerToken);
            } else {
                if (!self.authBearerToken) {
                    failureBlock(error);
                } else {
                    successBlock(self.authBearerToken);
                }
            }
        } else {
            failureBlock(error);
        }
    }];
    [task resume];
}


@end
