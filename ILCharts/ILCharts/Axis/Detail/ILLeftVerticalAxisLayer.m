#import "ILLeftVerticalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILAxisValuesLayerDelegate.h"
#import "ILVerticalAxisLayerCalculator.h"

#import "ILInternalChartView.h"

@implementation ILLeftVerticalAxisLayer

- (CGFloat)shortLineStartPos
{
    return self.bounds.size.width;
}

- (void)drawVerticalLineInContect:(CGContextRef)context
{
    CGContextSetLineWidth(context, [self axisWidth]);

    CGContextSetStrokeColorWithColor(context, [self axisColor ].CGColor);

    CGContextMoveToPoint(context, self.bounds.size.width, self.calculator.heightOffset);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - self.calculator.heightOffset);

    CGContextStrokePath(context);
}

- (void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->origin.x = fmaxf( self.chart.contentViewInsetsPtr->origin.x
                                                     , self.axis.size );
}

- (CGFloat)startXForBigDivision
{
    return self.bounds.size.width;
}

- (CGFloat)endXForBigDivision
{
    return self.bounds.size.width - [self bigDivisionsLength];
}

- (CGRect)actualRectForFrame
{
    return CGRectMake
    (
       -self.axis.size, 
       -self.calculator.heightOffset, 
        self.axis.size,
        self.chart.contentView.bounds.size.height + 2.f*self.calculator.heightOffset
    );
}

- (CGFloat)xCoordinateForValueTextDisplayingWithSize:(CGSize)textSize
{
    CGFloat textXGabarite = MAX(textSize.width, textSize.height);

    return self.bounds.size.width - textXGabarite - [self bigDivisionsLength] - 2.f;
}

#pragma mark- ILAxisValuesLayerDelegate

- (BOOL)isAxisVerticalForValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return YES;
}

-(BOOL)isAxisLeftForValuesLayer:(ILAxisValuesLayer *)valuesLayer_
{
    return YES;
}

@end
