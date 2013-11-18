#import <UIKit/UIKit.h>

@class ILChartView;

@interface BarsDemoViewController : UIViewController

@property (nonatomic, weak) IBOutlet ILChartView *chartView;

- (IBAction)onFlipBarsOrientation:(id)sender;
- (IBAction)onReloadChart:(id)sender;

@end
