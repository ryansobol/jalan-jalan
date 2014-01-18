#import "JLNLocationService.h"

@implementation JLNLocationService

- (id)init
{
  if ((self = [super init])) {
    _journey = [[JLNJourney alloc] init];

    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate        = self;
    self.locationManager.activityType    = CLActivityTypeFitness;
    self.locationManager.distanceFilter  = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  }

  return self;
}

#pragma mark - Change state

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
  if (!self.isDeferringUpdates) {
    [self.locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax
                                                            timeout:CLTimeIntervalMax];

    self.deferringUpdates = YES;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    [self.journey addLocations:locations];

    [self.delegate locationService:self journey:self.journey];
  });
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"locationManager:didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
  if (error) {
    switch (error.code) {
      case kCLErrorDeferredNotUpdatingLocation:
        // The location manager did not enter deferred mode because location updates were already disabled or paused.
        break;

      default:
        NSLog(@"locationManager:didFinishDeferredUpdatesWithError: %@", error);
        break;
    }
  }

  self.deferringUpdates = NO;
}

@end
