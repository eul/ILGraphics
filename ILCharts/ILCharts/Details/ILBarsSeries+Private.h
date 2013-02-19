#import "ILBarsSeries.h"

#import <Foundation/Foundation.h>

@class ILBarsSeriesCalculator;

@interface ILBarsSeries (Private)

@property (nonatomic, readonly) ILBarsSeriesCalculator *calculator;

@property (nonatomic, readonly) UIColor   *backgroundColor;
@property (nonatomic, readonly) CGFloat    borderWidth;
@property (nonatomic, readonly) UIColor   *borderColor;
@property (nonatomic, readonly) NSUInteger groupsCount;
@property (nonatomic, readonly) NSUInteger maxGroupSize;

- (BOOL)useAnimation;
- (BOOL)respondsToUserInteraction;

- (NSUInteger)numberOfBarsInGroup:(NSUInteger)groupIndex_;
- (CGFloat)valueForBarAtIndexPath:(NSIndexPath *)indexPath_;
- (UIColor*)fillColorForBarAtIndexPath:(NSIndexPath *)indexPath_;

- (BOOL)drawBarBorderForBarAtIndexPath:(NSIndexPath *)indexPath_;
- (BOOL)drawGradientForBarAtIndexPath:(NSIndexPath *)indexPath_;

- (CGFloat)borderWidthForBarAtIndexPath:(NSIndexPath *)indexPath_;
- (UIColor *)borderColorForBarAtIndexPath:(NSIndexPath *)indexPath_;

- (CGGradientRef)gradientForBarAtIndexPath:(NSIndexPath *)indexPath_;

- (NSString *)valueTextAtIndexPath:(NSIndexPath *)indexPath_;
- (NSString *)maxValueText;
- (UIFont *)valuesTextFont;

- (void)didTapBarAtIndexPath:(NSIndexPath *)indexPath_;

@end
