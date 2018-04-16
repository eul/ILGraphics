#import <UIKit/UIKit.h>

@class ILChartView;

@interface BarsDemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (nonatomic, weak) IBOutlet ILChartView *chartView;

- (IBAction)onFlipBarsOrientation:(id)sender;
- (IBAction)onReloadChart:(id)sender;

@end
