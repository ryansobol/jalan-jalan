#import "JLNJourney.h"

@protocol JLNLocationServiceDelegate;

@interface JLNLocationService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<JLNLocationServiceDelegate> delegate;

@property (nonatomic, strong) JLNJourney *journey;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, getter=isDeferringUpdates) BOOL deferringUpdates;

- (void)start;
- (void)stop;

@end

@protocol JLNLocationServiceDelegate <NSObject>

- (void)locationService:(JLNLocationService *)service journey:(JLNJourney *)journey;

@end
