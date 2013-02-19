#import "ILAxisValuesLayerCalculator.h"

#import "ILAxisValuesLayer.h"
#import "ILAxisValuesLayerDelegate.h"

#import "ILAxisValueState.h"

#include <vector>

@implementation ILAxisValuesLayerCalculator
{
    std::vector< NSRange > _filledRanges;
    NSMutableDictionary*   _states;
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
    self->_states = [NSMutableDictionary new];
}

- (void)resetState
{
    [self refresh];
    [self->_states removeAllObjects];
}

- (void)refresh
{
    self->_filledRanges.clear();
}

- (ILAxisValueState *)valueStateAtIndex:(NSUInteger)index
{
    [self calculateStateAtIndex: index];

    return self->_states[@(index)];
}

- (void)calculateStateAtIndex:(NSUInteger)index
{
    NSNumber *stateKey = @(index);

    ILAxisValueState *state = self->_states[stateKey];
    if ( !state)
    {
        state = [ILAxisValueState new];
        self->_states[stateKey] = state;
    }

    if ( !state.text)
    {
        state.text = [self.valuesLayer.delegate valuesLayer: self.valuesLayer
                                        textForValueAtIndex: index];
    }

    if ( !state.font)
    {
        state.font = [self.valuesLayer.delegate valuesLayer: self.valuesLayer
                                        fontForValueAtIndex: index];
    }

    state.frame = [self frameForValueAtIndex: index
                                  valueState: state];
}

- (CGRect)frameForValueAtIndex:(NSUInteger)index
                    valueState:(ILAxisValueState *)state
{
    CGPoint position = [self.valuesLayer.delegate valuesLayer: self.valuesLayer
                                      positionForValueAtIndex: index
                                                 withTextSize: state.textSize];

    if (position.x < -(MAXFLOAT+1.f) || position.y < -(MAXFLOAT+1))
        return CGRectZero;
    
    BOOL isVertical = [self.valuesLayer.delegate isAxisVerticalForValuesLayer: self.valuesLayer];
    BOOL isLeft     = [self.valuesLayer.delegate isAxisLeftForValuesLayer: self.valuesLayer];
    
    CGFloat valuesRotationAngle = [self.valuesLayer.delegate valueTextRotationAngleInValuesLayer: self.valuesLayer];

    CGFloat textXGabariteAfterRotation = state.textSize.width * (isVertical
                                                               ? sinf(valuesRotationAngle)
                                                               : cosf(valuesRotationAngle)) + 2.f;

    CGFloat textYGabariteAfterRotation = state.textSize.width *  (isVertical
                                                                ? cosf(valuesRotationAngle)
                                                                : sinf(valuesRotationAngle)) + 2.f;

    if ( !isVertical)
    {
        CGFloat diff = state.textSize.width - textXGabariteAfterRotation;

        if ( ![self.valuesLayer.delegate canDrawElementWithSize: state.textSize
                                                        atPoint: CGPointMake(position.x + diff /2.f, position.y)])
        {
            return CGRectZero;
        }
        if ( ![self.valuesLayer.delegate canDrawElementWithSize: state.textSize
                                                        atPoint: CGPointMake(position.x + state.textSize.width - diff /2.f, position.y)])
        {
            return CGRectZero;
        }

        diff = textYGabariteAfterRotation /2.f - state.textSize.height /2.f;

        position.y += isLeft ? -diff : diff;
    }
    else
    {
        CGFloat diff = textXGabariteAfterRotation /2.f - state.textSize.height /2.f;

        diff = diff > 0.f ? diff : 0.f;

        if ( ![self.valuesLayer.delegate canDrawElementWithSize: state.textSize
                                                        atPoint: CGPointMake(position.x, position.y - diff)])
        {
            return CGRectZero;
        }
        if ( ![self.valuesLayer.delegate canDrawElementWithSize: state.textSize
                                                        atPoint: CGPointMake(position.x, position.y + diff + state.textSize.height)])
        {
            return CGRectZero;
        }

        diff = state.textSize.width /2.f - textYGabariteAfterRotation /2.f;

        position.x += diff * ( isLeft ? 1 : -1 );
    }

    if ( ![self canDrawLabelAtPoint: position withSize: textXGabariteAfterRotation])
        return CGRectZero;

    NSUInteger location = [ self.valuesLayer.delegate isAxisVerticalForValuesLayer: self.valuesLayer ]
                          ? (NSUInteger)position.y
                          : (NSUInteger)position.x;

    NSRange range = {location, (NSUInteger)(textXGabariteAfterRotation)};
    self->_filledRanges.push_back(range);

    position.x = roundf(position.x);
    position.y = roundf(position.y);

    CGRect result = CGRectMake( position.x
                               , position.y
                               , state.textSize.width
                               , state.textSize.height);

    return result;
}

- (BOOL)canDrawLabelAtPoint:(CGPoint)point
                   withSize:(CGFloat)size
{
    NSUInteger delta = (NSUInteger)(size *0.1f);
    for ( size_t index = 0; index < self->_filledRanges.size(); ++index)
    {
        NSUInteger location = [ self.valuesLayer.delegate isAxisVerticalForValuesLayer: self.valuesLayer]
                              ? (NSUInteger)point.y
                              : (NSUInteger)point.x;

        if (NSLocationInRange(location + delta, self->_filledRanges[index])
          || NSLocationInRange((NSUInteger)(location + size - delta), self->_filledRanges[index]))
        {
            return NO;
        }
    }

    return YES;
}

@end
