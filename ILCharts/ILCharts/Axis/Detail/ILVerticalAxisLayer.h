#import "ILAxisLayer.h"

@class ILVerticalAxisLayerCalculator;

@interface ILVerticalAxisLayer : ILAxisLayer

@property (nonatomic, readonly) ILVerticalAxisLayerCalculator *calculator;

@property (nonatomic, readonly) CGFloat startXForBigDivision;
@property (nonatomic, readonly) CGFloat endXForBigDivision;

- (void)drawVerticalLineInContect:(CGContextRef)context;

- (CGFloat)xCoordinateForValueTextDisplayingWithSize:(CGSize)textSize;

@end
