#import "JLNJourney.h"
#import "JLNModelService.h"

@protocol JLNLocationServiceDelegate;

@interface JLNLocationService : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id<JLNLocationServiceDelegate> delegate;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) JLNModelService *modelService;
@property (nonatomic, strong) JLNJourney *journey;

@property (nonatomic, getter=isDeferringUpdates) BOOL deferringUpdates;

- (void)start;
- (void)stop;

@end

@protocol JLNLocationServiceDelegate <NSObject>

- (void)locationService:(JLNLocationService *)service journey:(JLNJourney *)journey;

@end
