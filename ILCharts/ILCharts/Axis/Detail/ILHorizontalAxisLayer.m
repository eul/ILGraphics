#import "ILHorizontalAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"

#import "ILInternalChartView.h"

#import "ILAxisValuesLayer.h"

@implementation ILHorizontalAxisLayer

- (void)updateContentViewInsets
{
    self.chart.contentViewInsetsPtr->size.height = fmaxf( self.chart.contentViewInsetsPtr->size.height
                                                         , self.axis.size );
}

- (CGFloat)fontSize
{
    static const CGFloat fontSize = 11.f;
    return fontSize;
}

- (CGFloat)widthOffset
{
    static const CGFloat widthOffset = 20.f;
    return widthOffset;
}

- (CGFloat)startOffset
{
    NSInteger pointsCount = [self.axis.delegate numberOfPointsForAxis: self.axis];
    if (0 == pointsCount)
        return 0.f;
    
    return [self useCenteredOffset]
           ? self.chart.contentSize.width /pointsCount/ 2.f
           : 0.f;
}

- (CGFloat)startYForBigDivision
{
    return 0.f;
}

- (CGFloat)endYForBigDivision
{
    return [self bigDivisionsLength];
}

- (BOOL)canDrawElementWithSize:(CGSize)elementSize
                       atPoint:(CGPoint)point
{
    return (point.x - elementSize.width )  <= self.chart.contentView.bounds.size.width + self.widthOffset
           && point.x >= 0.f;
}

- (BOOL)canDrawLineAtPoint:(CGFloat)currX
{
    return currX <= self.chart.contentView.bounds.size.width + self.widthOffset
        && currX >= self.widthOffset;
}

- (void)drawHorizontalLineInContect:(CGContextRef)context
{
    [self doesNotRecognizeSelector: _cmd];
}

- (void)drawBigDivisionsInContext:(CGContextRef)context
{
    [self doesNotRecognizeSelector: _cmd];
}

- (CGFloat)shortLineStartPos
{
    [self doesNotRecognizeSelector: _cmd];
    return 0.f;
}

- (void)drawShortLinesInContext:(CGContextRef)context
                   fromPosition:(CGFloat)x
                           step:(CGFloat)step
{
    if (!self.axis.drawShortDelimiters)
        return;

    CGContextSetLineWidth(context, [self shortDevisionsWidth]);
    CGContextSetStrokeColorWithColor(context, [self shortDivisionsColor ].CGColor);

    CGFloat smallStep = step /5.f;
    if ( smallStep < 2.f )
        return;

    for ( NSUInteger index = 1; index <= 4; ++index)
    {
        CGFloat currX = x - index*smallStep;

        if ( ![self canDrawLineAtPoint: currX])
            continue;

        CGFloat y1 = [self shortLineStartPos];
        CGFloat y2 = y1 - [self shortDevisionsLength];
        CGContextMoveToPoint(context, currX, y1);
        CGContextAddLineToPoint(context, currX, y2);
    }

    CGContextStrokePath(context);
}

- (void)drawInContext:(CGContextRef)context
{
    NSInteger numOfPoints = [self.axis.delegate numberOfPointsForAxis: self.axis];
    if (0 == numOfPoints)
        return;

    CGFloat hStep = self.chart.contentSize.width /numOfPoints;

    CGFloat startOffset = self.startOffset;

    CGFloat startBigDivisionY = self.startYForBigDivision;
    CGFloat endBigDivisionY   = self.endYForBigDivision;

    for (NSInteger index = 0; index <= numOfPoints; ++index)
    {
        CGFloat x = startOffset + index*hStep + self.widthOffset - self.chart.scrollView.contentOffset.x;

        [self drawShortLinesInContext: context
                         fromPosition: x
                                 step: hStep];

        if ( ![ self canDrawLineAtPoint: x])
            continue;

        CGContextSetLineWidth(context, [self bigDivisionsWidth]);
        CGContextSetStrokeColorWithColor(context, [self bigDivisionsColor].CGColor);

        CGContextMoveToPoint(context , x, startBigDivisionY);
        CGContextAddLineToPoint(context, x, endBigDivisionY);
    }
    
    CGContextStrokePath(context);

    [self drawHorizontalLineInContect: context];
}

- (CGFloat)yPositionForValueWithTextSize:(CGSize)textSize
{
    return self.endYForBigDivision + textSize.height /2.f;
}

#pragma mark- ILAxisValuesLayerDelegate

- (CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return [self labelsRotationAngleInRadians];
}

- (CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer
positionForValueAtIndex:(NSUInteger)index
           withTextSize:(CGSize)textSize
{
    CGFloat xStep = self.chart.contentSize.width /[self.axis.delegate numberOfPointsForAxis: self.axis];

    CGFloat x = self.startOffset + index *xStep + self.widthOffset - self.chart.scrollView.contentOffset.x;

    if (self.useCenteredOffsetForValues && !self.useCenteredOffset)
    {
        x += xStep /2.f;
    }

    CGPoint position = {x - textSize.width /2.f, [self yPositionForValueWithTextSize: textSize]};
    return position;
}

- (NSInteger)nearestValueIndexToPoint:(CGPoint)point
{
    NSInteger numOfPoints = [ self.axis.delegate numberOfPointsForAxis: self.axis];
    if (0 == numOfPoints)
        return -1;

    CGFloat xStep = self.chart.contentSize.width /numOfPoints;

    return (NSInteger)( ( point.x - self.startOffset - self.widthOffset ) / xStep);
}

@end
