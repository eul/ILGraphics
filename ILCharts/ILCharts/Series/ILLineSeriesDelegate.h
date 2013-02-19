#import <Foundation/Foundation.h>

@class UIColor;
@class ILLineSeries;

@protocol ILLineSeriesDelegate <NSObject>

@required
- (NSInteger)numberOfElementsForLineSeries:(ILLineSeries *)series;

- (float)lineSeries:(ILLineSeries *)series
       valueAtIndex:(NSUInteger)index;

- (UIColor*)colorForLineSeries:(ILLineSeries *)series;

@optional

- (BOOL)respondsToUserInteractionLineSeries:(ILLineSeries *)series;

- (NSUInteger)significantPointsCountForLineSeries:(ILLineSeries *)series;

- (BOOL)shouldShowValuesForLineSeries:(ILLineSeries *)series;

- (BOOL)useCenteredOffsetForLineSeries:(ILLineSeries *)series;

- (CGFloat)singlePointRadiusForLineSeries:(ILLineSeries *)series;
- (CGFloat)lineWidthForSeries:(ILLineSeries *)series;

//LineWidth, singlePointRadius and other size data must be adjusted by delegate.
- (CGFloat)verticalScaleFactorForSeries:(ILLineSeries *)series;

@end
