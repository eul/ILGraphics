#import "ILRightVerticalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILAxisValuesLayerDelegate.h"
#import "ILVerticalAxisLayerCalculator.h"

#import "ILInternalChartView.h"

@implementation ILRightVerticalAxisLayer

- (CGFloat)shortLineStartPos
{
    return [self shortDevisionsLength];
}

- (void)drawVerticalLineInContect:(CGContextRef)context
{
    CGContextSetLineWidth(context, [self axisWidth]);
    CGContextSetStrokeColorWithColor(context, [self axisColor].CGColor);

    CGContextMoveToPoint(context, 0.f, self.calculator.heightOffset);
    CGContextAddLineToPoint(context, 0.f, self.bounds.size.height - self.calculator.heightOffset);

    CGContextStrokePath(context);
}

- (CGRect)actualRectForFrame
{
    return CGRectMake
    (
       self.chart.contentView.bounds.size.width, 
       -self.calculator.heightOffset,
       self.axis.size, 
       self.chart.contentView.bounds.size.height + 2*self.calculator.heightOffset
    );
}

- (void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->size.width = fmaxf( self.chart.contentViewInsetsPtr->size.width
                                                       , self.axis.size );
}

- (CGFloat)startXForBigDivision
{
    return 0.f;
}

- (CGFloat)endXForBigDivision
{
    return [self bigDivisionsLength];
}

- (CGFloat)xCoordinateForValueTextDisplayingWithSize:(CGSize)textSize
{
    return [self bigDivisionsLength] + 2.f;
}

#pragma mark- ILAxisValuesLayerDelegate

- (BOOL)isAxisVerticalForValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return YES;
}

@end
