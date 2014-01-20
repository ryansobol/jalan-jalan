#import "JLNModelService.h"

@implementation JLNModelService

- (id)init
{
  if (self = [super init]) {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Jalan_Jalan" withExtension:@"momd"];

    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

    NSError *error;
    NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                 inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL    = [documentURL URLByAppendingPathComponent:@"Jalan_Jalan.sqlite"];

    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:storeURL
                                 options:nil
                                   error:&error]) {
      NSLog(@"JLNModelService: init - Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }

    _moc = [[NSManagedObjectContext alloc] init];
    [self.moc setPersistentStoreCoordinator:psc];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveContext)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveContext)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveContext)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
  }

  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (JLNJourney *)fetchOrInsertJourney
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  request.entity = [NSEntityDescription entityForName:@"Journey" inManagedObjectContext:self.moc];

  NSError *error;
  NSArray *results = [self.moc executeFetchRequest:request error:&error];

  if (error) {
    NSLog(@"JLNModelService: journey - Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }

  if (![results isEmpty]) {
    NSLog(@"JLNModelService: Fetching journey");
    return results[0];
  }

  NSLog(@"JLNModelService: Inserting journey");
  return [NSEntityDescription insertNewObjectForEntityForName:@"Journey"
                                       inManagedObjectContext:self.moc];
}

- (void)saveContext
{
  NSLog(@"JLNModelService: Saving context");

  NSError *error;

  if (self.moc && [self.moc hasChanges] && ![self.moc save:&error]) {
    NSLog(@"JLNModelService: saveContext - Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

@end
