#import <UIKit/UIKit.h>

@class ILChartView;

@interface LineDemoViewController : UIViewController

@property (nonatomic, weak) IBOutlet ILChartView *chartView;

- (IBAction)reloadAction:(id)sender;


@end
