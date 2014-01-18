#import "JLNLocationService.h"

@implementation JLNLocationService

- (id)init
{
  if ((self = [super init])) {
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.activityType    = CLActivityTypeFitness;
    self.locationManager.distanceFilter  = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  }

  return self;
}

- (void)start
{
  NSLog(@"JLNLocationService: Starting");

  [self.locationManager startUpdatingLocation];
}

- (void)stop
{
  NSLog(@"JLNLocationService: Stopping");

  [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate Service Notifications

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  NSString *message;

  switch (status) {
    case kCLAuthorizationStatusNotDetermined:
      message = @"Authorization Not Determined";
      break;

    case kCLAuthorizationStatusRestricted:
      message = @"Authorization Restricted";
      break;

    case kCLAuthorizationStatusDenied:
      message = @"Authorization Denied";
      break;

    case kCLAuthorizationStatusAuthorized:
      message = @"Authorized";
      break;
  }

  NSLog(@"JLNLocationService: %@", message);
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
  NSLog(@"JLNLocationService: Updates Paused");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
  NSLog(@"JLNLocationService: Updates Resumed");
}

#pragma mark - CLLocationManagerDelegate Location Notifications

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  // TODO: add location to a composite object
  for (CLLocation *location in locations) {
    NSLog(@"CLLocation: %@", location);
  }

  if (!self.isDeferringUpdates) {
    [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:CLTimeIntervalMax];

    self.deferringUpdates = YES;
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"NSError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
  if (error) NSLog(@"NSError: %@", error);

  self.deferringUpdates = NO;
}

@end
