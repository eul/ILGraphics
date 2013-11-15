#import "ILLineLayer.h"

#import "ILLineSeries.h"
#import "ILLineSeriesDelegate.h"

#include <vector>
#include <algorithm>

#include <cstdlib>
#include <cmath>
#include <limits>

typedef std::vector<CGPoint> CGPoint_vt;

@implementation ILLineLayer
{
    CGPoint_vt _firstControlPoints;
    CGPoint_vt _secondControlPoints;
}

- (CGFloat)singlePointRadius
{
    if ([self.lineSeries.delegate respondsToSelector:@selector(singlePointRadiusForLineSeries:)])
    {
        return [self.lineSeries.delegate singlePointRadiusForLineSeries:self.lineSeries];
    }

    return 10.f;
}

- (CGFloat)lineWidth
{
    if ([self.lineSeries.delegate respondsToSelector:@selector(lineWidthForSeries:)])
    {
        return [self.lineSeries.delegate lineWidthForSeries: self.lineSeries];
    }

    return 3.5f;    
}

- (CGFloat)verticalTrashhold
{
    if ([self.lineSeries.delegate respondsToSelector:@selector(verticalScaleFactorForSeries:)])
    {
        return [self.lineSeries.delegate verticalScaleFactorForSeries: self.lineSeries];
    }
    
    return 1.f;    
}

- (CGFloat)startOffset
{
    NSInteger numOfPoints = [self.lineSeries.delegate respondsToSelector:@selector(significantPointsCountForLineSeries:)]
                            ? static_cast<NSInteger>([self.lineSeries.delegate significantPointsCountForLineSeries:self.lineSeries])
                            : [self.lineSeries.delegate numberOfElementsForLineSeries:self.lineSeries];
    if (0 == numOfPoints)
        return 0.f;

    BOOL useOffset = NO;
    if ([self.lineSeries.delegate respondsToSelector: @selector(useCenteredOffsetForLineSeries:)])
        useOffset = [self.lineSeries.delegate useCenteredOffsetForLineSeries: self.lineSeries];

    return useOffset
           ? self.bounds.size.width /numOfPoints /2.f
           :  0.f;
}

- (void)reloadData
{
    [self setNeedsDisplay];
}

- (void)reloadDataInRect:(CGRect)rect
               scrolling:(BOOL)scrolling
{
    [self reloadData];
}

- (NSUInteger)pointsCount
{
    NSInteger rawPointsCount = [self.lineSeries.delegate numberOfElementsForLineSeries: self.lineSeries];
    NSUInteger pointsCount   = static_cast<NSUInteger>(rawPointsCount);

    return pointsCount;
}

// using C++11 move constructors
- (CGPoint_vt)getPoints
{
    NSUInteger pointsCount = [self pointsCount];

    CGPoint_vt userPoints;
    userPoints.reserve(pointsCount);

    float stepX = (self.bounds.size.width - [self startOffset] *2.f) /((pointsCount > 1) ? (pointsCount -1) : pointsCount);

    for ( NSUInteger i = 0; i < pointsCount; ++i)
    {
        float value = [self.lineSeries.delegate lineSeries:self.lineSeries
                                              valueAtIndex:i];

        CGPoint point = {stepX * i, self.bounds.size.height - self.bounds.size.height * value};

        userPoints.push_back(point);
    }

    return userPoints;
}

- (void)drawLines:(const CGPoint_vt& )userPoints
        inContext:(CGContextRef)context
{
    NSUInteger pointsCount = userPoints.size();

    CGContextSetLineWidth(context, [self lineWidth]);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, userPoints[0].x, userPoints[0].y);
    for (NSUInteger i = 0; i < pointsCount; ++i)
    {
        CGContextAddLineToPoint(context, userPoints[i].x, userPoints[i].y);
    }
    CGContextStrokePath(context);
}

- (void)drawPoint:(CGPoint)point
        inContext:(CGContextRef)context
{
    CGFloat radius = [self singlePointRadius];
    CGFloat diametr = 2.f *radius;

    CGRect pointRect =
    {
        {point.x - radius, point.y - radius},
        {diametr, diametr}
    };
    CGContextFillEllipseInRect(context, pointRect);
}

- (void)drawInContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);

    NSUInteger pointsCount = [self pointsCount];
    
    if (pointsCount < 1)
    {
        return;
    }

    CGAffineTransform transform =
    {
        1.f,                      0.f, //0.f,
        0.f, [self verticalTrashhold], //0.f
        [self startOffset],       0.f, //1.f
    };

    CGContextConcatCTM(context, transform);

    [[self.lineSeries.delegate colorForLineSeries: self.lineSeries] set];

    if (1 == pointsCount)
    {
        [self drawPoint: [self getPoints].at(0)
              inContext: context];
    }
    else
    {
        [self drawLines: [self getPoints]
              inContext: context];
    }
    UIGraphicsPopContext();
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    if (hitLayer == self)
    {
        if ([self.lineSeries.delegate respondsToSelector: @selector(respondsToUserInteractionLineSeries:)]
          && [ self.lineSeries.delegate respondsToUserInteractionLineSeries: self.lineSeries])
        {
           return self;
        }
        else
        {
            return nil;
        }
    }

    return hitLayer;
}

@end
