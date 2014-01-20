@interface JLNJourney : NSManagedObject

@property (nonatomic, strong) NSArray *locations;

- (void)addLocations:(NSArray *)locations;
- (MKPolyline *)polyLineOverlay;

@end
