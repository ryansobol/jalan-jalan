#import "JLNAppDelegate.h"

@implementation JLNAppDelegate

#pragma mark - Application States

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSLog(@"Application state: Launch");

  self.window.tintColor = [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1.0];

  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  NSLog(@"Application state: Active");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  NSLog(@"Application state: Inactive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  NSLog(@"Application state: Background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  NSLog(@"Application state: Foreground");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  NSLog(@"Application state: Terminate");
}

#pragma mark - System Notifications

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
  NSLog(@"System Notification: Memory warning");
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
  NSLog(@"System Notification: Significant time change");
}

@end
