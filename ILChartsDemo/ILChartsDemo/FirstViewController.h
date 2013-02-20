#import <UIKit/UIKit.h>

@class ILChartView;

@interface FirstViewController : UIViewController

@property (nonatomic, weak) IBOutlet ILChartView *chartView;

- (IBAction)onFlipBarsOrientation:(id)sender;
- (IBAction)onReloadChart:(id)sender;

@end
