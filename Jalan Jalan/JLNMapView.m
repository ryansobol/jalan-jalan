#import "JLNMapView.h"

@implementation JLNMapView

- (id)initWithCoder:(NSCoder *)coder
{
  if (self = [super initWithCoder:coder]) {
    self.delegate          = self;
    self.userTrackingMode  = MKUserTrackingModeFollow;
    self.showsUserLocation = YES;
  }

  return self;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
  MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];

  renderer.lineWidth   = 6.0;
  renderer.strokeColor = [[[UIApplication sharedApplication] keyWindow] tintColor];

  return renderer;
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
  switch (mode) {
    case MKUserTrackingModeNone:
      NSLog(@"JLNMapView: Not tracking user location. Retrying.");
      self.userTrackingMode = MKUserTrackingModeFollow;
      break;

    case MKUserTrackingModeFollow:
      NSLog(@"JLNMapView: Tracking user location");
      break;

    case MKUserTrackingModeFollowWithHeading:
      NSLog(@"JLNMapView: Tracking user location and heading");
      break;
  }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
  switch (error.code) {
    case kCLErrorLocationUnknown:
      NSLog(@"JLNMapView: Unable to obtain a location.");
      // NOTE: Sometimes the simulator emits this error and stops trying to obtain a location.
      // So far, I haven't found a way to manually recover from this scenario.
      break;

    default:
      NSLog(@"mapView:didFailToLocateUserWithError: %@", error);
      break;
  }
}

@end
