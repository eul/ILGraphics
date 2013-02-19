#import "ILAxisLayer.h"

@interface ILHorizontalAxisLayer : ILAxisLayer

@property (nonatomic, readonly) CGFloat fontSize;
@property (nonatomic, readonly) CGFloat widthOffset;
@property (nonatomic, readonly) CGFloat startYForBigDivision;
@property (nonatomic, readonly) CGFloat endYForBigDivision;

- (BOOL)canDrawLineAtPoint:(CGFloat)currX;

- (void)drawHorizontalLineInContect:(CGContextRef)context;

- (CGFloat)yPositionForValueWithTextSize:(CGSize)textSize;

@end
