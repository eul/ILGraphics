#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

@class ILChartView;

@protocol ILChartViewInternalDelegate <NSObject>

- (void)chartViewDidChangeContentSize:(ILChartView *)chart_;

- (void)chartView:(ILChartView *)chart_
  didScrollToRect:(CGRect)visibleRect_
        scrolling:(BOOL)scrolling_;

@end
