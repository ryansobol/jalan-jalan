#import "JLNJourney.h"

@interface JLNModelService : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *moc;

- (JLNJourney *)fetchOrInsertJourney;
- (void)saveContext;

@end
