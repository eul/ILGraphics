#import "ILPiesContainerLayer.h"

#import "ILPieSeriesDelegate.h"
#import "ILPieSeries.h"

#import "ILPieSliceLayer.h"
#import "ILPieSliceLayerDelegate.h"

#import "ILChartsMath.h"

static const CGFloat angleInProcent = (float)DOUBLE_M_PI / 100.f;

@interface ILPiesContainerLayer() <ILPieSliceLayerDelegate>

@end

@implementation ILPiesContainerLayer
{
    NSUInteger            _selectedSlice;
    NSMutableDictionary * _slicesValueRects;
}

- (instancetype)initWithPieSeries:(ILPieSeries *)series
{
    self = [super init];
    if (self)
    {
        self.pieSeries    = series;
        _selectedSlice    = NSIntegerMax;
        _slicesValueRects = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (void)reloadDataInRect:(CGRect)rect_
               scrolling:(BOOL)scrolling_
{
    [self reloadData];
}

- (void)reloadData
{
    if (NSIntegerMax != _selectedSlice)
    {
        [self moveSliceLayer:self.sublayers[_selectedSlice] inside:YES];
    }

    _selectedSlice = NSIntegerMax;

    [self updateSlices];
}

- (void)updateSlices
{
    [_slicesValueRects removeAllObjects];
    
    [self updateSliceCount];
    
	CGFloat startAngle = [self startAngle];
    BOOL showValues    = [self showValues];
    BOOL useGradient   = [self useGradient];

    NSUInteger slicesCount = [self.pieSeries.delegate numberOfElementsForPieChartSeries:self.pieSeries];
    
    UIFont* valuesFont  = [UIFont fontWithName: @"Helvetica Neue" size: 12];
    CGPoint sliceCenter = [self sliceCenter];

	for (NSUInteger i = 0; i < slicesCount; ++i)
    {
        CGFloat sliceValue = [self.pieSeries.delegate pieChartSeries:self.pieSeries valueAtIndex:i];

		CGFloat angle = sliceValue * angleInProcent;
        
        ILPieSliceLayer *slice = self.sublayers[i];

        slice.sliceId       = i;
        slice.drawGradient  = useGradient;
        slice.startAngle    = DOUBLE_M_PI - (startAngle + angle);
        slice.endAngle      = DOUBLE_M_PI - startAngle;
        slice.sliceDelegate = self;
        slice.valueText     = [[NSString alloc] initWithFormat: @"%.2f%%", sliceValue];
        slice.showValue     = NO;
        slice.fillColor     = [self.pieSeries.delegate pieChartSeries:self.pieSeries colorAtIndex:i];
        slice.center        = sliceCenter;
        slice.valuesFont    = valuesFont;
        slice.showValue     = showValues;

        startAngle += angle;
	}

}

-(void)updateSliceCount
{
    NSUInteger slicesCount = [self.pieSeries.delegate numberOfElementsForPieChartSeries:self.pieSeries];

	if (slicesCount > self.sublayers.count)
    {
        NSUInteger count = slicesCount - self.sublayers.count;
		for (NSUInteger i = 0; i < count; ++i)
        {
			ILPieSliceLayer *slice = [ILPieSliceLayer new];

			slice.frame = self.bounds;

			[self addSublayer:slice];
		}
	}
	else if (slicesCount < self.sublayers.count)
    {
		NSUInteger count = self.sublayers.count - slicesCount;

		for (NSUInteger i = 0; i < count; ++i)
        {
            [self.sublayers[0] removeFromSuperlayer];
		}
	}
}

- (CGFloat)startAngle
{
    return [self.pieSeries.delegate respondsToSelector: @selector(startAngleInRadiansForPieChartSeries:)]
            ? [self.pieSeries.delegate startAngleInRadiansForPieChartSeries: self.pieSeries]
            : 0.f;
}

- (BOOL)showValues
{
    return [self.pieSeries.delegate respondsToSelector: @selector(shouldShowValuesForPieChartSeries:)]
            ? [self.pieSeries.delegate shouldShowValuesForPieChartSeries: self.pieSeries]
            : YES;
}

- (BOOL)useGradient
{
    return NO;
}

- (CGPoint)sliceCenter
{
    return CGPointMake(self.bounds.size.width /2.f , self.bounds.size.height /2.f);
}

#pragma mark- Slise movement

- (void)selectSliceAtIndex:(NSUInteger)sliceIndex
{
    if (NSIntegerMax != _selectedSlice)
    {
        [self moveSliceLayer:self.sublayers[_selectedSlice] inside:YES];
        //[self.delegate pieChartView: self didDeselectSliceAtIndex: self.selectedSlice ];
        
        if (_selectedSlice == sliceIndex)
        {
            _selectedSlice = NSIntegerMax;
            return;
        }
    }
    
    if (sliceIndex >= self.sublayers.count)
    {
        _selectedSlice = NSIntegerMax;
        return;
    }

    [self moveSliceLayer:self.sublayers[sliceIndex] inside:NO];
    _selectedSlice = sliceIndex;
    //[self.delegate pieChartView: self didSelectSliceAtIndex: self.selectedSlice ];
}

- (void)hadleTapAtPoint:(CGPoint)touchPoint
{
    if (self.sublayers.count < 2)
    {
        return;
    }

    CGFloat angle = [ILChartsMath angleBetweenPoint:touchPoint andPoint:[self sliceCenter]];

    if (self.startAngle > 0.f)
    {
        int koef = int(floorf(self.startAngle / (float)DOUBLE_M_PI));
        angle += DOUBLE_M_PI * koef;
    }

    NSUInteger index = 0;
    
    for (ILPieSliceLayer *sliceLayer in self.sublayers)
    {
        CGFloat distanceToSliceCenter = sqrtf(powf(touchPoint.x - sliceLayer.position.x, 2) + powf(touchPoint.y - sliceLayer.position.y, 2));
        
        if (distanceToSliceCenter < sliceLayer.radius)
        {
            if ((angle < sliceLayer.endAngle && angle > sliceLayer.startAngle)
                //|| ( angle_ + DOUBLE_M_PI < sliceLayer_.endAngle && angle_ + DOUBLE_M_PI > sliceLayer_.startAngle )*/ )
                )
            {
                [self selectSliceAtIndex:index];
            }
        }
        ++index;
    }
}

- (void)moveSliceLayer:(ILPieSliceLayer *)slice inside:(BOOL)isInside
{
    CGFloat midleAngle = (slice.startAngle + slice.endAngle) /2.f;
    
    CGPoint newPosition = CGPointZero;
    
    CGFloat selectionShiftDistance = slice.radius /4.f;

    CGFloat x = roundf(slice.position.x + selectionShiftDistance * cosf(midleAngle) * (isInside ? -1 : 1 ) );
    CGFloat y = roundf(slice.position.y + selectionShiftDistance * sinf(midleAngle) * (isInside ? -1 : 1 ) );
    newPosition = CGPointMake(x, y);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration: 0.15f];

    slice.position = newPosition;

    [CATransaction commit];
}

- (CGRect)intersectRectForRect:(CGRect)rect
                 forSliceLayer:(ILPieSliceLayer *)sliceLayer
{
    __block CGRect intersectRect = CGRectZero;
    __weak  ILPiesContainerLayer *weakSelf = self;
    
    [_slicesValueRects enumerateKeysAndObjectsUsingBlock: ^(NSNumber *layerId, NSValue *rectValue, BOOL *stop)
    {
        NSUInteger index       = [layerId unsignedIntegerValue];
        ILPieSliceLayer *layer = weakSelf.sublayers[index];
         if (sliceLayer.sliceId != layer.sliceId)
         {
             if (CGRectIntersectsRect(rectValue.CGRectValue, rect))
             {
                 intersectRect = rectValue.CGRectValue;
                 *stop = YES;
             }
         }
     } ];
    return intersectRect;
}

- (CGRect)shiftToAvoidIntersectionInSlice:(ILPieSliceLayer *)sliceLayer
                                     rect:(CGRect)rect
                                 withRect:(CGRect)targetRect
{
    CGRect intersectionRect = CGRectIntersection(rect,  targetRect);

    if (intersectionRect.size.height < intersectionRect.size.width )
    {
        NSInteger yShiftDirection = rect.origin.y > sliceLayer.center.y ? 1 : -1;
        
        rect.origin.y = targetRect.origin.y + yShiftDirection * targetRect.size.height;
    }
    else
    {
        NSInteger xShiftDirection = rect.origin.x > sliceLayer.center.x ? 1 : -1;
        
        rect.origin.x = targetRect.origin.x + xShiftDirection * targetRect.size.width;
    }
    
    return rect;
}

#pragma mark- PieSliceLayerDelegate

- (CGRect)sliceLayer:(ILPieSliceLayer *)sliceLayer
bestRectForDrawValueInRect:(CGRect)rect
{
    CGRect intersectRect = [self intersectRectForRect:rect forSliceLayer:sliceLayer];
    
    if (!CGRectIsEmpty(intersectRect))
    {
        rect = [self shiftToAvoidIntersectionInSlice:sliceLayer
                                                rect:rect
                                            withRect:intersectRect];
        
        rect = [self sliceLayer:sliceLayer bestRectForDrawValueInRect:rect];
    }
    
    return rect;
}

- (void)sliceLayer:(ILPieSliceLayer *)sliceLayer
didDrawValueInRect:(CGRect)rect
{
    _slicesValueRects[@(sliceLayer.sliceId)] = [NSValue valueWithCGRect:rect];
}

@end
