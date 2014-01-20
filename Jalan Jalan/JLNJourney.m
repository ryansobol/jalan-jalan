#import "JLNJourney.h"

@implementation JLNJourney

@dynamic locations;

- (void)awakeFromInsert
{
  [super awakeFromInsert];

  self.locations = @[];
}

- (void)addLocations:(NSArray *)locations
{
  self.locations = [self.locations arrayByAddingObjectsFromArray:locations];
}

- (MKPolyline *)polyLineOverlay
{
  NSInteger total = self.locations.count;

  CLLocationCoordinate2D coordinates[total];

  for (NSInteger index = 0; index < total; index++) {
    CLLocation *location = self.locations[index];
    coordinates[index] = location.coordinate;
  }

  return [MKPolyline polylineWithCoordinates:coordinates count:total];
}

@end
