#import "ILHorizontalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILInternalChartView.h"

#import "ILAxisValuesLayer.h"

@implementation ILHorizontalAxisLayer

-(void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->size.height = fmaxf( self.chart.contentViewInsetsPtr->size.height
                                                         , self.axis.size );
}

-(CGFloat)fontSize
{
    static const CGFloat fontSize_ = 11.f;
    return fontSize_;
}

-(CGFloat)widthOffset
{
    static const CGFloat widthOffset_ = 20.f;
    return widthOffset_;
}

-(CGFloat)startOffset
{
    NSInteger numOfPoints_ = [ self.axis.delegate numberOfPointsForAxis: self.axis ];
    if ( 0 == numOfPoints_ )
        return 0.f;
    
    return [ self useCenteredOffset ]
           ? self.chart.contentSize.width / numOfPoints_ / 2.f
           :  0.f;
}

-(CGFloat)startYForBigDivision
{
    return 0.f;
}

-(CGFloat)endYForBigDivision
{
    return [ self bigDivisionsLength ];
}

-(BOOL)canDrawElementWithSize:( CGSize )elementSize_
                      atPoint:( CGPoint )point_
{
    return (point_.x - elementSize_.width )  <= self.chart.contentView.bounds.size.width + self.widthOffset
         && point_.x >= 0.f;
}

-(BOOL)canDrawLineAtPoint:( CGFloat )currX_
{
    return currX_ <= self.chart.contentView.bounds.size.width + self.widthOffset
        && currX_ >= self.widthOffset;
}

-(void)drawHorizontalLineInContect:( CGContextRef )context_
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(void)drawBigDivisionsInContext:( CGContextRef )context_
{
    [ self doesNotRecognizeSelector: _cmd ];    
}

-(CGFloat)shortLineStartPos
{
    [ self doesNotRecognizeSelector: _cmd ];    
    return 0.f;
}

-(void)drawShortLinesInContext:( CGContextRef )context_
                  fromPosition:( CGFloat )x_
                          step:( CGFloat )step_
{
    if ( !self.axis.drawShortDelimiters )
        return;

    CGContextSetLineWidth( context_, [ self shortDevisionsWidth ]  );
    CGContextSetStrokeColorWithColor( context_, [ self shortDivisionsColor ].CGColor );

    CGFloat smallStep_ = step_ / 5.f;
    if ( smallStep_ < 2.f )
        return;

    for ( NSUInteger index_ = 1; index_ <= 4; ++index_ )
    {
        CGFloat currX_ = x_ - index_*smallStep_;

        if ( ![ self canDrawLineAtPoint: currX_ ] )
            continue;

        CGFloat y1_ = [ self shortLineStartPos ];
        CGFloat y2_ = y1_ - [ self shortDevisionsLength ];
        CGContextMoveToPoint( context_ , currX_, y1_ );
        CGContextAddLineToPoint( context_, currX_, y2_ );
    }

    CGContextStrokePath( context_ );
}

-(void)drawInContext:( CGContextRef )context_
{
    NSInteger numOfPoints_ = [ self.axis.delegate numberOfPointsForAxis: self.axis ];
    if ( 0 == numOfPoints_ )
        return;

    CGFloat hStep_ = self.chart.contentSize.width / numOfPoints_;

    CGFloat startOffset_ = self.startOffset;

    CGFloat startBigDivisionY_ = self.startYForBigDivision;
    CGFloat endBigDivisionY_   = self.endYForBigDivision;

    for ( NSInteger index_ = 0; index_ <= numOfPoints_; ++index_ )
    {
        CGFloat x_ = startOffset_ + index_*hStep_ + self.widthOffset - self.chart.scrollView.contentOffset.x;

        [ self drawShortLinesInContext: context_
                          fromPosition: x_
                                  step: hStep_ ];

        if ( ![ self canDrawLineAtPoint: x_ ] )
            continue;

        CGContextSetLineWidth( context_, [ self bigDivisionsWidth ]  );
        CGContextSetStrokeColorWithColor( context_, [ self bigDivisionsColor ].CGColor );

        CGContextMoveToPoint( context_ , x_, startBigDivisionY_ );
        CGContextAddLineToPoint( context_, x_, endBigDivisionY_ );
    }
    
    CGContextStrokePath( context_ );
    
    [ self drawHorizontalLineInContect: context_ ];
}

-(CGFloat)yPositionForValueWithTextSize:( CGSize )textSize_
{
    return self.endYForBigDivision + textSize_.height / 2.f;
}

#pragma mark- ILAxisValuesLayerDelegate

-(CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer_
{
    return [ self labelsRotationAngleInRadians ];
}

-(CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer_
positionForValueAtIndex:( NSUInteger )index_
           withTextSize:( CGSize )textSize_
{
    CGFloat xStep_ = self.chart.contentSize.width / [ self.axis.delegate numberOfPointsForAxis: self.axis ];

    CGFloat x_ =  self.startOffset + index_ * xStep_ + self.widthOffset - self.chart.scrollView.contentOffset.x;

    if ( self.useCenteredOffsetForValues && !self.useCenteredOffset )
    {
        x_ += xStep_ / 2.f;
    }

    CGPoint position_ = { x_ - textSize_.width / 2.f, [ self yPositionForValueWithTextSize: textSize_ ] };
    return position_;
}

-(NSInteger)nearestValueIndexToPoint:( CGPoint )point_
{
    NSInteger numOfPoints_ = [ self.axis.delegate numberOfPointsForAxis: self.axis ];
    if ( 0 == numOfPoints_ )
        return -1;

    CGFloat xStep_ = self.chart.contentSize.width / numOfPoints_;

    return (NSInteger)( ( point_.x - self.startOffset - self.widthOffset ) / xStep_ );
}

@end
