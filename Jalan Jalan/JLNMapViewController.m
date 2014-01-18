#import "JLNMapViewController.h"

@implementation JLNMapViewController

- (id)initWithCoder:(NSCoder *)coder
{
  if ((self = [super initWithCoder:coder])) {
    _locationService = [[JLNLocationService alloc] init];
    self.locationService.delegate = self;
  }

  return self;
}

#pragma mark - Actions

- (IBAction)tapStart:(UIButton *)sender
{
  NSLog(@"JLNMapViewController: tapStart");

  [self.locationService start];

  self.startButton.hidden = YES;
  self.stopButton.hidden  = NO;
}

- (IBAction)tapStop:(UIButton *)sender
{
  NSLog(@"JLNMapViewController: tapStop");

  [self.locationService stop];

  self.stopButton.hidden  = YES;
  self.startButton.hidden = NO;
}

#pragma mark - JLNLocationServiceDelegate

- (void)locationService:(JLNLocationService *)service journey:(JLNJourney *)journey
{
  [self.mapView removeOverlays:self.mapView.overlays];
  [self.mapView addOverlay:journey.polyLineOverlay];
}

@end
