@interface JLNLocationService : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, getter=isDeferringUpdates) BOOL deferringUpdates;

- (void)start;
- (void)stop;

@end
