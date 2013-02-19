#import "ILAxisValuesLayer.h"

#import "ILAxisValuesLayerDelegate.h"
#import "ILAxisValueLayer.h"

#import "ILAxisValuesLayerCalculator.h"
#import "ILAxisValueState.h"

#include <vector>

@implementation ILAxisValuesLayer
{
    ILAxisValuesLayerCalculator* _calculator;
    CGRect                       _visibleRect;
    NSInteger                    _firstVisibleIndex;
    NSInteger                    _lastVisibleIndex;
}

-(id)init
{
    self = [ super init ];
    if ( self )
    {
        [ self initialize ];
    }
    
    return self;
}

-(void)initialize
{
    self->_calculator = [ ILAxisValuesLayerCalculator new ];
    self->_calculator.valuesLayer = self;
}

-(void)reloadDataInRect:( CGRect )rect_
              scrolling:( BOOL )scrolling_
{
    if ( !scrolling_ )
    {
        [ self->_calculator resetState ];
    }
    else
    {
        [ self->_calculator refresh ];
    }

    CGFloat newX_ = rect_.origin.x - ( rect_.size.width  / 2.f );
    CGFloat newY_ = rect_.origin.y - ( rect_.size.height / 2.f );

    rect_.origin.x = ( newX_ > 0.f ) ? newX_ : 0.f;
    rect_.origin.y = ( newY_ > 0.f ) ? newY_: 0.f;
    rect_.size.width  *= 2.f;
    rect_.size.height *= 2.f;

    self->_visibleRect = rect_;

    [ self updateValueLayersCount ];
    [ self setNeedsDisplay ];
}

-(void)updateValueLayersCount
{
    NSUInteger valuesCount_ = [ self.delegate numberOfValuesInValuesLayer: self ];

    NSInteger value1_ = [ self.delegate nearestValueIndexToPoint: CGPointMake( CGRectGetMaxX( self->_visibleRect ), CGRectGetMaxY( self->_visibleRect )) ];
    NSInteger value2_ = [ self.delegate nearestValueIndexToPoint: self->_visibleRect.origin ];

    self->_firstVisibleIndex = MIN( value1_, value2_ ) - 1;
    self->_lastVisibleIndex  = MAX( value1_, value2_ ) + 1;

    if ( self->_firstVisibleIndex < 0 )
        self->_firstVisibleIndex = 0;

    if ( self->_lastVisibleIndex < 0 || self->_lastVisibleIndex >= (NSInteger)valuesCount_ )
        self->_lastVisibleIndex = (NSInteger)valuesCount_;

    NSUInteger layersCount_ = (NSUInteger)(self->_lastVisibleIndex - self->_firstVisibleIndex);

    if ( layersCount_ > self.sublayers.count )
    {
        NSUInteger sublayersCount_ = self.sublayers.count;
        NSUInteger deltaCount_ = layersCount_ - sublayersCount_;
        
        for ( NSUInteger i = 0; i < deltaCount_; ++i )
        {
            ILAxisValueLayer* valueLayer_ = [ ILAxisValueLayer new ];
            valueLayer_.frame = CGRectZero;

            [ self addSublayer: valueLayer_ ];
        }
    }
    else if ( layersCount_ < self.sublayers.count )
    {
        NSUInteger deltaCount_ = self.sublayers.count - layersCount_;

        for ( NSUInteger i = 0; i < deltaCount_; ++i )
        {
            [ self.sublayers[ 0 ] removeFromSuperlayer ];
        }
    }
}

-(void)drawInContext:( CGContextRef )context_
{
    UIGraphicsPushContext( context_ );

    CGFloat valuesRotationAngle_ = [self.delegate valueTextRotationAngleInValuesLayer: self ];

    NSUInteger layerCounter_ = 0;
    
    for ( NSInteger index_ = self->_firstVisibleIndex; index_ < self->_lastVisibleIndex; ++index_ )
    {
        ILAxisValueLayer* valueLayer_ = (ILAxisValueLayer*)self.sublayers[ layerCounter_++ ];

        ILAxisValueState* valueState_ = [ self->_calculator valueStateAtIndex: (NSUInteger)index_ ];

        CGRect frame_ = valueState_.frame;
        valueLayer_.frame = frame_;

        if ( CGRectIsEmpty( frame_ ) )
            continue;

        valueLayer_.text = valueState_.text;
        valueLayer_.font = valueState_.font;
        valueLayer_.rotationAngle = valuesRotationAngle_;
    }

    UIGraphicsPopContext();
}

-(CALayer *)hitTest:( CGPoint )point_
{
    CALayer* hitLayer_ = [ super hitTest: point_ ];

    return hitLayer_ == self ? nil : hitLayer_;
}

@end
