#import "ILLeftHorizontalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILInternalChartView.h"

#import "ILAxisValuesLayer.h"

#import <QuartzCore/QuartzCore.h>

@implementation ILLeftHorizontalAxisLayer

-(CGFloat)shortLineStartPos
{
    return self.bounds.size.height;
}

-(void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->origin.y = fmaxf( self.chart.contentViewInsetsPtr->origin.y
                                                      , self.axis.size );
}

-(CGRect)actualRectForFrame
{
    return CGRectMake( -self.widthOffset
                     , -self.axis.size
                     , self.chart.contentView.bounds.size.width + 2.f * self.widthOffset
                     , self.axis.size );
}

-(void)drawHorizontalLineInContect:( CGContextRef )context_
{
    CGContextSetLineWidth( context_, [ self axisWidth ]  );
    CGContextSetStrokeColorWithColor( context_, [ self axisColor ].CGColor );
    
    CGContextMoveToPoint( context_, self.widthOffset - 2.f, self.axis.size );
    CGContextAddLineToPoint( context_, self.bounds.size.width - self.widthOffset + 2.f, self.axis.size );
    
    CGContextStrokePath( context_ );
}

-(CGFloat)startYForBigDivision
{
    return self.axis.size;
}

-(CGFloat)endYForBigDivision
{
    return self.axis.size - [ self bigDivisionsLength ];
}

-(CGFloat)yPositionForValueWithTextSize:( CGSize )textSize_
{
    return [ self endYForBigDivision ] - textSize_.height - 2.f;
}

-(BOOL)isAxisLeftForValuesLayer:( SCAxisValuesLayer* )valuesLayer_
{
    return YES;
}

@end
