#import "ILVerticalAxisLayer.h"

#import "ILInternalChartView.h"
#import "ILAxis.h"
#import "ILAxisDelegate.h"
#import "ILAxisValuesLayer.h"

#import "ILVerticalAxisLayerCalculator.h"

@implementation ILVerticalAxisLayer
{
    ILVerticalAxisLayerCalculator* _calculator;
}

-(ILVerticalAxisLayerCalculator*)calculator
{
    if ( !self->_calculator )
    {
        self->_calculator = [ILVerticalAxisLayerCalculator new];
        self->_calculator.axisLayer    = self;
        self->_calculator.heightOffset = 0.f;
    }
    return self->_calculator;
}

-(void)reloadData
{
    [ self->_calculator resetState ];
    [ super reloadData ];
}

-(void)drawInContext:( CGContextRef )context_
{
    if ( 0 == self.calculator.divisionsCount )
    {
        return;
    }

    [ self drawVerticalLineInContect: context_ ];

    CGFloat startBigDivisionX_ = self.startXForBigDivision;
    CGFloat endBigDivisionX_   = self.endXForBigDivision;

    for ( NSUInteger index_ = 0; index_ < (NSUInteger)self.calculator.divisionsCount + 1; ++index_ )
    {
        CGFloat y_ = [ self.calculator yPositionAtIndex: index_ ];

        [ self drawShortLinesInContext: context_
                          fromPosition: y_
                                  step: self.calculator.divisionsStep ];

        if ( ![ self.calculator canDrawElementWithSize: CGSizeZero
                                           atYPosition: y_ ] )
            continue;

        CGContextSetLineWidth( context_, [ self bigDivisionsWidth ]  );
        CGContextSetStrokeColorWithColor( context_, [ self bigDivisionsColor ].CGColor );

        CGContextMoveToPoint( context_ , startBigDivisionX_, y_ );
        CGContextAddLineToPoint( context_, endBigDivisionX_, y_ );
    }

    CGContextStrokePath( context_ );
}

-(void)drawVerticalLineInContect:(CGContextRef)context_
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(CGFloat)startXForBigDivision
{
    return 0.f;
}

-(CGFloat)endXForBigDivision
{
    return [ self bigDivisionsLength ];
}

-(void)hadleTapAtPoint:( CGPoint )tapPoint_
{
    if ( [ self.axis.delegate respondsToSelector: @selector( axis:didTapPoint:atIndex: ) ] )
    {
        [ self.axis.delegate axis: self.axis 
                      didTapPoint: tapPoint_ 
                          atIndex: [ self axisPointWithTapPoint: tapPoint_ ] ];
    }
}

-(NSInteger)axisPointWithTapPoint:( CGPoint )tapPoint_
{
    for ( NSUInteger index_ = 0; index_ < (NSUInteger)self.calculator.divisionsCount + 1; ++index_ )
    {
        if ( tapPoint_.y > [ self.calculator yPositionAtIndex: index_ ] )
            return (NSInteger)index_ - 1;
    }

    return NSNotFound;
}

-(CGFloat)xCoordinateForValueTextDisplayingWithSize:( CGSize )textSize_
{
    return MAXFLOAT;
}

#pragma mark- ILAxisValuesLayerDelegate

-(CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer_
positionForValueAtIndex:(NSUInteger )index_
           withTextSize:(CGSize )textSize_
{
    return [self.calculator positionForValueAtIndex: index_
                                        withTextSize: textSize_];
}

-(CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer_
{
    return [self labelsRotationAngleInRadians];
}

-(BOOL)canDrawElementWithSize:(CGSize )elementSize_
                      atPoint:(CGPoint )point_
{
    return [self.calculator canDrawElementWithSize: elementSize_
                                       atYPosition: point_.y];
}

-(NSInteger)nearestValueIndexToPoint:( CGPoint )point_
{
    NSInteger numOfPoints_ = (NSInteger)self.calculator.divisionsCount;
    if ( 0 == numOfPoints_ )
        return -1;

    CGFloat yStep_ = self.chart.contentSize.height / numOfPoints_;

    return numOfPoints_ - (NSInteger)(point_.y / yStep_ );
}

@end
