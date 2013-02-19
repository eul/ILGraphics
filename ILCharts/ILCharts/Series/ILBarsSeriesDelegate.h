#import <Foundation/Foundation.h>

#include <CoreGraphics/CoreGraphics.h>

@class UIColor;
@class ILBarsSeries;

@protocol ILBarsSeriesDelegate <NSObject>

- (NSUInteger)numberOfGroupsInBarsSeries:(ILBarsSeries *)series;
- (NSUInteger)barsSeries:(ILBarsSeries *)barSeries numberOfBarsInGroup:(NSUInteger)groupIndex;

/// value is expected in [0..1] interval
- (CGFloat)barsSeries:(ILBarsSeries *)barSeries valueForBarAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (BOOL)respondsToUserInteractionBarsSeries:(ILBarsSeries *)barSeries;
- (void)barsSeries:(ILBarsSeries *)barSeries didSelectBarAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (BOOL)useAnimationInBarsSeries:(ILBarsSeries *)barSeries;

@optional
/// if bars are Vertical it means max group width - horizontal - height
- (NSUInteger)maxGroupSizeInBarsSeries:(ILBarsSeries *)series;

- (UIColor *)barsSeries:(ILBarsSeries *)barSeries fillColorForBarAtIndexPath:(NSIndexPath *)indexPath;

- (UIColor *)backgroundColorForBarsSeries:(ILBarsSeries *)series;

- (CGFloat)borderWidthForBarsSeries:(ILBarsSeries *)series;
- (UIColor *)borderColorForBarsSeries:(ILBarsSeries *)series;

- (BOOL)barsSeries:(ILBarsSeries *)barSeries drawBarBorderForBarAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)barsSeries:(ILBarsSeries *)barSeries drawGradientForBarAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)barsSeries:(ILBarsSeries *)barSeries borderWidthForBarAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)barsSeries:(ILBarsSeries *)barSeries borderColorForBarAtIndexPath:(NSIndexPath *)indexPath;

- (CGGradientRef)barsSeries:(ILBarsSeries *)barSeries gradientForBarAtIndexPath:(NSIndexPath *)indexPath;

@optional
/// recomended to specify in case you define SCBarsSeries as dataSource for SCValuesSeries
- (NSString *)barsSeries:(ILBarsSeries *)barSeries valueTextAtIndexPath:( NSIndexPath *)indexPath;
- (NSString *)maxValueTextForBarsSeries:(ILBarsSeries*)barSeries;
- (UIFont *)valuesTextFontInBarsSeries:(ILBarsSeries *)series;

@end
