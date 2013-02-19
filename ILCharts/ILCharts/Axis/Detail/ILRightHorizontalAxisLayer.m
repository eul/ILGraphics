#import "ILRightHorizontalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILAxisValuesLayerDelegate.h"

#import "ILInternalChartView.h"

static const CGFloat widthOffset_ = 20.f;
static const CGFloat axisOffset_  = 0.f;

@implementation ILRightHorizontalAxisLayer

-(CGFloat)shortLineStartPos
{
    return [ self shortDevisionsLength ];
}

-(void)drawHorizontalLineInContect:( CGContextRef )context_
{
    CGContextSetLineWidth( context_, [ self axisWidth ]  );
    CGContextSetStrokeColorWithColor( context_, [ self axisColor ].CGColor );

    CGContextMoveToPoint( context_, widthOffset_ - 2.f, axisOffset_ );
    CGContextAddLineToPoint( context_, self.bounds.size.width - widthOffset_ + 2.f, axisOffset_ );

    CGContextStrokePath( context_ );
}

-(CGRect)actualRectForFrame
{
    return CGRectMake
    (
       -widthOffset_, 
       self.chart.contentView.bounds.size.height,
       self.chart.contentView.bounds.size.width + 2*widthOffset_, 
       self.axis.size
    );
}

@end
