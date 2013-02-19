#import "ILRightHorizontalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILAxisValuesLayerDelegate.h"

#import "ILInternalChartView.h"

static const CGFloat widthOffset_ = 20.f;
static const CGFloat axisOffset_  = 0.f;

@implementation ILRightHorizontalAxisLayer

- (CGFloat)shortLineStartPos
{
    return [self shortDevisionsLength];
}

- (void)drawHorizontalLineInContect:(CGContextRef)context
{
    CGContextSetLineWidth(context, [self axisWidth]);
    CGContextSetStrokeColorWithColor(context, [self axisColor].CGColor);

    CGContextMoveToPoint(context, widthOffset_ - 2.f, axisOffset_);
    CGContextAddLineToPoint(context, self.bounds.size.width - widthOffset_ + 2.f, axisOffset_ );

    CGContextStrokePath(context);
}

- (CGRect)actualRectForFrame
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
