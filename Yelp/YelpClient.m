//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"
#import <CoreLocation/CoreLocation.h>

@interface YelpClient () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) CLLocationManager *locationManager;


@end

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
        self.longitude = @"-122.394556";
        self.latitude = @"37.774866";
        
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSLog(@"lat, long %@ %@", self.latitude, self.longitude);
    NSDictionary *defaults = @{@"term": term, @"ll" : [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude]};
    NSMutableDictionary *allParameters = [defaults mutableCopy];
    if (params) {
        [allParameters addEntriesFromDictionary:params];
    }
    
    return [self GET:@"search" parameters:allParameters success:success failure:failure];
}

// Wait for location callbacks
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"change lat, long %@ %@", self.latitude, self.longitude);

    self.latitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"didUpdateToLocation");}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
    [manager stopUpdatingLocation];
}


@end
