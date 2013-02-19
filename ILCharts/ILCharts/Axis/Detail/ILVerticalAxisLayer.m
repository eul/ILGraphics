#import "ILVerticalAxisLayer.h"

#import "ILInternalChartView.h"
#import "ILAxis.h"
#import "ILAxisDelegate.h"
#import "ILAxisValuesLayer.h"

#import "ILVerticalAxisLayerCalculator.h"

@implementation ILVerticalAxisLayer
{
    ILVerticalAxisLayerCalculator *_calculator;
}

- (ILVerticalAxisLayerCalculator *)calculator
{
    if ( !self->_calculator)
    {
        self->_calculator = [ILVerticalAxisLayerCalculator new];
        self->_calculator.axisLayer    = self;
        self->_calculator.heightOffset = 0.f;
    }
    return self->_calculator;
}

- (void)reloadData
{
    [self->_calculator resetState];
    [super reloadData];
}

- (void)drawInContext:(CGContextRef)context
{
    if (0 == self.calculator.divisionsCount)
    {
        return;
    }

    [self drawVerticalLineInContect: context];

    CGFloat startBigDivisionX = self.startXForBigDivision;
    CGFloat endBigDivisionX   = self.endXForBigDivision;

    for (NSUInteger index = 0; index < (NSUInteger)self.calculator.divisionsCount + 1; ++index)
    {
        CGFloat y = [self.calculator yPositionAtIndex: index];

        [self drawShortLinesInContext: context
                         fromPosition: y
                                 step: self.calculator.divisionsStep];

        if ( ![ self.calculator canDrawElementWithSize: CGSizeZero
                                           atYPosition: y])
            continue;

        CGContextSetLineWidth(context, [self bigDivisionsWidth]);
        CGContextSetStrokeColorWithColor(context, [self bigDivisionsColor ].CGColor);

        CGContextMoveToPoint(context, startBigDivisionX, y);
        CGContextAddLineToPoint(context, endBigDivisionX, y);
    }

    CGContextStrokePath(context);
}

- (void)drawVerticalLineInContect:(CGContextRef)context
{
    [self doesNotRecognizeSelector: _cmd];
}

- (CGFloat)startXForBigDivision
{
    return 0.f;
}

- (CGFloat)endXForBigDivision
{
    return [self bigDivisionsLength];
}

- (void)hadleTapAtPoint:(CGPoint)tapPoint
{
    if ([self.axis.delegate respondsToSelector: @selector(axis:didTapPoint:atIndex:)])
    {
        [ self.axis.delegate axis: self.axis 
                      didTapPoint: tapPoint
                          atIndex: [self axisPointWithTapPoint: tapPoint]];
    }
}

- (NSInteger)axisPointWithTapPoint:(CGPoint)tapPoint
{
    for ( NSUInteger index = 0; index < (NSUInteger)self.calculator.divisionsCount + 1; ++index)
    {
        if ( tapPoint.y > [self.calculator yPositionAtIndex: index])
            return (NSInteger)index - 1;
    }

    return NSNotFound;
}

- (CGFloat)xCoordinateForValueTextDisplayingWithSize:(CGSize)textSize
{
    return MAXFLOAT;
}

#pragma mark- ILAxisValuesLayerDelegate

- (CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer
positionForValueAtIndex:(NSUInteger)index
           withTextSize:(CGSize)textSize
{
    return [self.calculator positionForValueAtIndex: index
                                       withTextSize: textSize];
}

- (CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return [self labelsRotationAngleInRadians];
}

- (BOOL)canDrawElementWithSize:(CGSize)elementSize
                       atPoint:(CGPoint)point
{
    return [self.calculator canDrawElementWithSize: elementSize
                                       atYPosition: point.y];
}

-(NSInteger)nearestValueIndexToPoint:( CGPoint )point
{
    NSInteger numOfPoints = (NSInteger)self.calculator.divisionsCount;
    if ( 0 == numOfPoints )
        return -1;

    CGFloat yStep = self.chart.contentSize.height /numOfPoints;

    return numOfPoints - (NSInteger)(point.y / yStep);
}

@end
