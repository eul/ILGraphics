#import "ILLeftHorizontalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILInternalChartView.h"

#import "ILAxisValuesLayer.h"

#import <QuartzCore/QuartzCore.h>

@implementation ILLeftHorizontalAxisLayer

- (CGFloat)shortLineStartPos
{
    return self.bounds.size.height;
}

- (void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->origin.y = fmaxf( self.chart.contentViewInsetsPtr->origin.y
                                                      , self.axis.size );
}

- (CGRect)actualRectForFrame
{
    return CGRectMake( -self.widthOffset
                     , -self.axis.size
                     , self.chart.contentView.bounds.size.width + 2.f * self.widthOffset
                     , self.axis.size );
}

- (void)drawHorizontalLineInContect:(CGContextRef)context
{
    CGContextSetLineWidth(context, [self axisWidth]);
    CGContextSetStrokeColorWithColor(context, [self axisColor].CGColor);
    
    CGContextMoveToPoint(context, self.widthOffset - 2.f, self.axis.size);
    CGContextAddLineToPoint(context, self.bounds.size.width - self.widthOffset + 2.f, self.axis.size);
    
    CGContextStrokePath(context);
}

- (CGFloat)startYForBigDivision
{
    return self.axis.size;
}

- (CGFloat)endYForBigDivision
{
    return self.axis.size - [self bigDivisionsLength];
}

- (CGFloat)yPositionForValueWithTextSize:(CGSize)textSize
{
    return [self endYForBigDivision] - textSize.height - 2.f;
}

- (BOOL)isAxisLeftForValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return YES;
}

@end
