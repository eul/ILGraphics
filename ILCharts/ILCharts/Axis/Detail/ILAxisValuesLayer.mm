#import "ILAxisValuesLayer.h"

#import "ILAxisValuesLayerDelegate.h"
#import "ILAxisValueLayer.h"

#import "ILAxisValuesLayerCalculator.h"
#import "ILAxisValueState.h"

#include <vector>

@implementation ILAxisValuesLayer
{
    ILAxisValuesLayerCalculator *_calculator;
    CGRect                       _visibleRect;
    NSInteger                    _firstVisibleIndex;
    NSInteger                    _lastVisibleIndex;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self->_calculator = [ILAxisValuesLayerCalculator new];
    self->_calculator.valuesLayer = self;
}

- (void)reloadDataInRect:(CGRect)rect
               scrolling:(BOOL)scrolling
{
    if (!scrolling)
    {
        [self->_calculator resetState];
    }
    else
    {
        [self->_calculator refresh];
    }

    CGFloat newX = rect.origin.x - (rect.size.width  /2.f);
    CGFloat newY = rect.origin.y - (rect.size.height /2.f);

    rect.origin.x = (newX > 0.f) ? newX : 0.f;
    rect.origin.y = (newY > 0.f) ? newY: 0.f;
    rect.size.width  *= 2.f;
    rect.size.height *= 2.f;

    self->_visibleRect = rect;

    [self updateValueLayersCount];
    [self setNeedsDisplay];
}

- (void)updateValueLayersCount
{
    NSUInteger valuesCount = [self.delegate numberOfValuesInValuesLayer: self];

    NSInteger value1 = [self.delegate nearestValueIndexToPoint: CGPointMake(CGRectGetMaxX(self->_visibleRect), CGRectGetMaxY( self->_visibleRect))];
    NSInteger value2 = [ self.delegate nearestValueIndexToPoint: self->_visibleRect.origin ];

    self->_firstVisibleIndex = MIN(value1, value2) - 1;
    self->_lastVisibleIndex  = MAX(value1, value2) + 1;

    if ( self->_firstVisibleIndex < 0 )
        self->_firstVisibleIndex = 0;

    if ( self->_lastVisibleIndex < 0 || self->_lastVisibleIndex >= (NSInteger)valuesCount)
        self->_lastVisibleIndex = (NSInteger)valuesCount;

    NSUInteger layersCount = (NSUInteger)(self->_lastVisibleIndex - self->_firstVisibleIndex);

    if ( layersCount > self.sublayers.count )
    {
        NSUInteger sublayersCount = self.sublayers.count;
        NSUInteger deltaCount = layersCount - sublayersCount;
        
        for ( NSUInteger i = 0; i < deltaCount; ++i )
        {
            ILAxisValueLayer* valueLayer = [ ILAxisValueLayer new ];
            valueLayer.frame = CGRectZero;

            [self addSublayer: valueLayer];
        }
    }
    else if ( layersCount < self.sublayers.count)
    {
        NSUInteger deltaCount = self.sublayers.count - layersCount;

        for ( NSUInteger i = 0; i < deltaCount; ++i )
        {
            [self.sublayers[0] removeFromSuperlayer];
        }
    }
}

- (void)drawInContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);

    CGFloat valuesRotationAngle = [self.delegate valueTextRotationAngleInValuesLayer: self];

    NSUInteger layerCounter = 0;
    
    for ( NSInteger index = self->_firstVisibleIndex; index < self->_lastVisibleIndex; ++index)
    {
        ILAxisValueLayer* valueLayer = (ILAxisValueLayer*)self.sublayers[layerCounter++];

        ILAxisValueState* valueState = [self->_calculator valueStateAtIndex: (NSUInteger)index];

        CGRect frame = valueState.frame;
        valueLayer.frame = frame;

        if ( CGRectIsEmpty(frame))
            continue;

        valueLayer.text = valueState.text;
        valueLayer.font = valueState.font;
        valueLayer.rotationAngle = valuesRotationAngle;
    }

    UIGraphicsPopContext();
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    return hitLayer == self ? nil : hitLayer;
}

@end
