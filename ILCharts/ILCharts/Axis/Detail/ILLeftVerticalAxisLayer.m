#import "ILLeftVerticalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILAxisValuesLayerDelegate.h"
#import "ILVerticalAxisLayerCalculator.h"

#import "ILInternalChartView.h"

@implementation ILLeftVerticalAxisLayer

-(CGFloat)shortLineStartPos
{
    return self.bounds.size.width;
}

-(void)drawVerticalLineInContect:( CGContextRef )context_
{
    CGContextSetLineWidth(context_, [self axisWidth]);

    CGContextSetStrokeColorWithColor(context_, [self axisColor ].CGColor );

    CGContextMoveToPoint( context_, self.bounds.size.width, self.calculator.heightOffset );
    CGContextAddLineToPoint( context_, self.bounds.size.width, self.bounds.size.height - self.calculator.heightOffset );

    CGContextStrokePath( context_ );
}

-(void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->origin.x = fmaxf( self.chart.contentViewInsetsPtr->origin.x
                                                     , self.axis.size );
}

-(CGFloat)startXForBigDivision
{
    return self.bounds.size.width;
}

-(CGFloat)endXForBigDivision
{
    return self.bounds.size.width - [self bigDivisionsLength];
}

-(CGRect)actualRectForFrame
{
    return CGRectMake
    (
       -self.axis.size, 
       -self.calculator.heightOffset, 
        self.axis.size,
        self.chart.contentView.bounds.size.height + 2.f*self.calculator.heightOffset
    );
}

-(CGFloat)xCoordinateForValueTextDisplayingWithSize:( CGSize )textSize_
{
    CGFloat textXGabarite_ = MAX(textSize_.width, textSize_.height);

    return self.bounds.size.width - textXGabarite_ - [self bigDivisionsLength] - 2.f;
}

#pragma mark- ILAxisValuesLayerDelegate

-(BOOL)isAxisVerticalForValuesLayer:(ILAxisValuesLayer *)valuesLayer_
{
    return YES;
}

-(BOOL)isAxisLeftForValuesLayer:(ILAxisValuesLayer *)valuesLayer_
{
    return YES;
}

@end
