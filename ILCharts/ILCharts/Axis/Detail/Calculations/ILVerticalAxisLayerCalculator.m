#import "ILVerticalAxisLayerCalculator.h"

#import "ILVerticalAxisLayer.h"
#import "ILAxisLayer.h"
#import "ILInternalChartView.h"
#import "ILAxis.h"
#import "ILAxisDelegate.h"

@implementation ILVerticalAxisLayerCalculator
{
    CGFloat                   _startOffset;
    id< ILInternalChartView > _chartView;
    BOOL                      _useCenteredOffsetForValues;
    BOOL                      _useCenteredOffsetForValuesInitialized;
    BOOL                      _useCenteredOffset;
    BOOL                      _useCenteredOffsetInitialized;
    NSInteger                 _divisionsCount;
}

-(void)resetState
{
    self->_startOffset = MAXFLOAT;
    self->_chartView   = nil;
    self->_useCenteredOffsetForValuesInitialized = NO;
    self->_useCenteredOffsetInitialized          = NO;
    self->_divisionsCount                        = -1;
}

-(BOOL)canDrawElementWithSize:( CGSize )elementSize_
                  atYPosition:( CGFloat )yPosition_
{
    if ( yPosition_ + elementSize_.height < self.heightOffset
      || yPosition_ - elementSize_.height > self.axisLayer.frame.size.height - self.heightOffset )
    {
        return NO;
    }

    return YES;
}

-(NSInteger)divisionsCount
{
    if ( self->_divisionsCount )
    {
        [ self setDivisionsCount: (NSInteger)[ self.axisLayer.axis.delegate numberOfPointsForAxis: self.axisLayer.axis ] ];
    }
    return self->_divisionsCount;
}

-(void)setDivisionsCount:( NSInteger )divisionsCount_
{
    self->_divisionsCount = divisionsCount_;
    self->_divisionsStep  = self.chartView.contentSize.height / self->_divisionsCount;
}

-(BOOL)useCenteredOffsetForValues
{
    if ( ! self->_useCenteredOffsetForValuesInitialized )
    {
        self->_useCenteredOffsetForValues = self.axisLayer.useCenteredOffsetForValues;
        self->_useCenteredOffsetForValuesInitialized = YES;
    }
    return self->_useCenteredOffsetForValues;
}

-(BOOL)useCenteredOffset
{
    if ( ! self->_useCenteredOffsetForValuesInitialized )
    {
        self->_useCenteredOffset = self.axisLayer.useCenteredOffset;
        self->_useCenteredOffsetInitialized = YES;
    }
    return self->_useCenteredOffset;
}

-(CGFloat)startOffset
{
    if ( MAXFLOAT == self->_startOffset )
    {
        if ( 0 == self.divisionsCount )
        {
            self->_startOffset = 0.f;
        }
        else
        {
            self->_startOffset = self.useCenteredOffset
                                 ? self.chartView.contentSize.height / self.divisionsCount / 2.f
                                 : 0.f;
        }
    }
    return self->_startOffset;
}

-(id< ILInternalChartView >)chartView
{
    if ( ! self->_chartView )
    {
        self->_chartView = self.axisLayer.chart;
    }
    return self->_chartView;
}

-(CGFloat)yPositionAtIndex:( NSUInteger )pointIndex_
{
    return self.chartView.contentSize.height - pointIndex_ * self.divisionsStep + self.heightOffset
           - self.chartView.scrollView.contentOffset.y - self.startOffset;
}

-(NSUInteger)indexByYPosition:( CGFloat )yPosition_
{
    return (NSUInteger)( ( self.chartView.contentSize.height - yPosition_ + self.heightOffset - self.chartView.scrollView.contentOffset.y - self.startOffset ) / self.divisionsStep );
}

-(CGPoint)positionForValueAtIndex:( NSUInteger )index_
                     withTextSize:( CGSize )textSize_
{
    if ( 0 == self.divisionsCount )
        return CGPointMake( -MAXFLOAT, -MAXFLOAT);

    CGFloat yStep_ = self.chartView.contentSize.height / self.divisionsCount;

    CGFloat y_ = self.chartView.contentSize.height - index_*yStep_ + self.heightOffset - self.chartView.scrollView.contentOffset.y - self.startOffset;
    
    if ( self.useCenteredOffsetForValues && !self.useCenteredOffset )
    {
        y_ -= yStep_ / 2.f;
    }

    CGPoint position_ = { [ self.axisLayer xCoordinateForValueTextDisplayingWithSize: textSize_ ], y_ - textSize_.height / 1.5f };
    return position_;
}

@end
