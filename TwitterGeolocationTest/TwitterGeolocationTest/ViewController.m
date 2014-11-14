//
//  ViewController.m
//  TwitterGeolocationTest
//
//  Created by David Okun on 11/13/14.
//  Copyright (c) 2014 okundotio. All rights reserved.
//

#import "ViewController.h"
#import "ValueTransformer.h"
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, setter=setCurrentLocation:) CLLocation *currentLocation;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    [[ValueTransformer sharedTransformer] getTweetsForLocation:self.currentLocation withSuccessBlock:^(NSArray *tweetAnnotationArray) {
        //Add annotations to map here given objects
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Could not load any tweets" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        _mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    region.span = span;
    region.center = currentLocation.coordinate;
    
    [_mapView setCenterCoordinate:region.center animated:TRUE];
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    
}
@end
