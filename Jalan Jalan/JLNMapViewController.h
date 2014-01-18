#import "JLNLocationService.h"
#import "JLNMapView.h"

@interface JLNMapViewController : UIViewController <JLNLocationServiceDelegate>

@property (nonatomic, strong) IBOutlet JLNMapView *mapView;
@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIButton *stopButton;

- (IBAction)tapStart:(UIButton *)sender;
- (IBAction)tapStop:(UIButton *)sender;

@property (nonatomic, strong) JLNLocationService *locationService;

@end
