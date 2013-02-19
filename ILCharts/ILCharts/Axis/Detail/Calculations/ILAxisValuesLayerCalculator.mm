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
    self->_states = [ NSMutableDictionary new ];
}

-(void)resetState
{
    [ self refresh ];
    [ self->_states removeAllObjects ];
}

-(void)refresh
{
    self->_filledRanges.clear();
}

-(SCAxisValueState*)valueStateAtIndex:( NSUInteger )index_
{
    [ self calculateStateAtIndex: index_ ];

    return self->_states[ @( index_ ) ];
}

-(void)calculateStateAtIndex:( NSUInteger )index_
{
    NSNumber* stateKey_ = @( index_ );

    ILAxisValueState* state_ = self->_states[ stateKey_ ];
    if ( !state_ )
    {
        state_ = [ ILAxisValueState new ];
        self->_states[ stateKey_ ] = state_;
    }

    if ( !state_.text )
    {
        state_.text = [ self.valuesLayer.delegate valuesLayer: self.valuesLayer
                                          textForValueAtIndex: index_ ];
    }

    if ( !state_.font )
    {
        state_.font = [ self.valuesLayer.delegate valuesLayer: self.valuesLayer
                                          fontForValueAtIndex: index_ ];
    }

    state_.frame = [ self frameForValueAtIndex: index_
                                    valueState: state_ ];
}

-(CGRect)frameForValueAtIndex:( NSUInteger )index_
                   valueState:( ILAxisValueState* )state_
{
    CGPoint position_ = [ self.valuesLayer.delegate valuesLayer: self.valuesLayer
                                        positionForValueAtIndex: index_
                                                   withTextSize: state_.textSize ];
    
    if ( position_.x < -(MAXFLOAT+1.f) || position_.y < -(MAXFLOAT+1) )
        return CGRectZero;
    
    BOOL isVertical_ = [ self.valuesLayer.delegate isAxisVerticalForValuesLayer: self.valuesLayer ];
    BOOL isLeft_     = [ self.valuesLayer.delegate isAxisLeftForValuesLayer: self.valuesLayer ];
    
    CGFloat valuesRotationAngle_ = [ self.valuesLayer.delegate valueTextRotationAngleInValuesLayer: self.valuesLayer ];

    CGFloat textXGabariteAfterRotation_ = state_.textSize.width *  ( isVertical_
                                                                     ? sinf( valuesRotationAngle_ )
                                                                     : cosf( valuesRotationAngle_ ) ) + 2.f;

    CGFloat textYGabariteAfterRotation_ = state_.textSize.width *  ( isVertical_
                                                                     ? cosf( valuesRotationAngle_ )
                                                                     : sinf( valuesRotationAngle_ ) ) + 2.f;

    if ( !isVertical_ )
    {
        CGFloat diff_ = state_.textSize.width - textXGabariteAfterRotation_;

        if ( ! [ self.valuesLayer.delegate canDrawElementWithSize: state_.textSize
                                                          atPoint: CGPointMake( position_.x + diff_ / 2.f, position_.y ) ] )
        {
            return CGRectZero;
        }
        if ( ! [ self.valuesLayer.delegate canDrawElementWithSize: state_.textSize
                                                          atPoint: CGPointMake( position_.x + state_.textSize.width - diff_/ 2.f, position_.y ) ] )
        {
            return CGRectZero;
        }

        diff_ = textYGabariteAfterRotation_/2.f - state_.textSize.height/2.f;

        position_.y += isLeft_ ? -diff_ : diff_;
    }
    else
    {
        CGFloat diff_ = textXGabariteAfterRotation_ / 2.f - state_.textSize.height / 2.f;

        diff_ = diff_ > 0.f ? diff_ : 0.f;

        if ( ! [ self.valuesLayer.delegate canDrawElementWithSize: state_.textSize
                                                          atPoint: CGPointMake( position_.x , position_.y - diff_) ] )
        {
            return CGRectZero;
        }
        if ( ! [ self.valuesLayer.delegate canDrawElementWithSize: state_.textSize
                                                          atPoint: CGPointMake( position_.x , position_.y + diff_ + state_.textSize.height ) ] )
        {
            return CGRectZero;
        }

        diff_ = state_.textSize.width / 2.f - textYGabariteAfterRotation_ / 2.f;

        position_.x += diff_ * ( isLeft_ ? 1 : -1 );
    }

    if ( ![ self canDrawLabelAtPoint: position_ withSize: textXGabariteAfterRotation_ ] )
        return CGRectZero;

    NSUInteger location_ = [ self.valuesLayer.delegate isAxisVerticalForValuesLayer: self.valuesLayer ]
                            ? (NSUInteger)position_.y
                            : (NSUInteger)position_.x;

    NSRange range_ = { location_, (NSUInteger)( textXGabariteAfterRotation_ )  };
    self->_filledRanges.push_back( range_ );

    position_.x = roundf( position_.x );
    position_.y = roundf( position_.y );

    CGRect result_ = CGRectMake( position_.x
                                , position_.y
                                , state_.textSize.width
                                , state_.textSize.height );

    return result_;
}

-(BOOL)canDrawLabelAtPoint:( CGPoint )point_
                  withSize:( CGFloat )size_
{
    NSUInteger delta_ = (NSUInteger)(size_ * 0.1f);
    for ( size_t index_ = 0; index_ < self->_filledRanges.size(); ++index_ )
    {
        NSUInteger location_ = [ self.valuesLayer.delegate isAxisVerticalForValuesLayer: self.valuesLayer ]
                               ? (NSUInteger)point_.y
                               : (NSUInteger)point_.x;

        if ( NSLocationInRange( location_ + delta_, self->_filledRanges[ index_ ] )
          || NSLocationInRange( (NSUInteger)( location_ + size_ - delta_ ), self->_filledRanges[ index_ ] ) )
        {
            return NO;
        }
    }

    return YES;
}


@end
