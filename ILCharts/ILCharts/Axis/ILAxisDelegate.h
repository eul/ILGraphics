#import <Foundation/Foundation.h>

@class ILAxis;

@protocol ILAxisDelegate <NSObject>

@required
- (NSInteger)numberOfPointsForAxis:(ILAxis *)axis;

-( NSString *)axis:(ILAxis *)axis
labelTextForPoint:(NSInteger)point;

@optional
/// Tap handling

- (void)axis:(ILAxis *)axis
didTapPoint:(CGPoint)point
    atIndex:(NSInteger)index;

///Offset methods

- (BOOL)useCenteredOffsetForAxis:(ILAxis *)axis;

- (BOOL)useCenteredOffsetForValuesInAxis:(ILAxis *)axis;

///Skin

- (CGFloat)labelsRotationAngleInDegreesForAxis:(ILAxis *)axis;

- (UIColor*)colorForAxis:(ILAxis *)axis;

- (CGFloat)widthForAxis:(ILAxis *)axis;

- (UIColor*)backgroundColorForAxis:(ILAxis *)axis;

- (UIColor*)shortDivisionsColorForAxis:(ILAxis *)axis;

- (CGFloat)shortDivisionsLengthForAxis:(ILAxis *)axis;

- (CGFloat)shortDivisionsWidthForAxis:(ILAxis *)axis;

- (CGFloat)bigDivisionsLengthForAxis:(ILAxis *)axis;

- (CGFloat)bigDivisionsWidthForAxis:(ILAxis *)axis;

- (UIColor *)bigDivisionsColorForAxis:(ILAxis *)axis;

- (UIFont *)axis:(ILAxis *)axis
fontForLabelAtPoint:(NSInteger)point;

- (UIColor *)axis:(ILAxis *)axis
colorForLabelAtPoint:(NSInteger)point;

@end
