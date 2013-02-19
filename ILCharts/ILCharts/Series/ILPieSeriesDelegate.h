#import <Foundation/Foundation.h>

@class UIColor;
@class ILPieSeries;

@protocol ILPieSeriesDelegate <NSObject>

@required
- (NSUInteger)numberOfElementsForPieChartSeries:(ILPieSeries *)series;

- (float)pieChartSeries:(ILPieSeries *)series
           valueAtIndex:(NSUInteger)index;

- (UIColor *)pieChartSeries:(ILPieSeries *)series
               colorAtIndex:(NSUInteger)index;

@optional

- (BOOL)shouldShowValuesForPieChartSeries:(ILPieSeries *)series;

- (CGFloat)startAngleInRadiansForPieChartSeries:(ILPieSeries *)series;

@end
