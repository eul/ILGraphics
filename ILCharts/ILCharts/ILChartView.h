#import <UIKit/UIKit.h>

@protocol ILAxis;
@protocol ILSeries;

@interface ILChartView : UIView

@property (nonatomic) CGSize contentSize;
@property (nonatomic) BOOL   scrollFromTop;

@property (nonatomic, weak, readonly) UIView *contentView;

- (void)addAxis:(id< ILAxis >)axis_;
- (void)addSeries:(id< ILSeries >)series_;

- (void)reloadData;

- (CGRect)getContentViewFrame;

@end
