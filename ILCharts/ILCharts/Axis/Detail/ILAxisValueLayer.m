#import "ILAxisValueLayer.h"

@implementation ILAxisValueLayer

-(id<CAAction>)actionForKey:( NSString* )event_
{
	return nil;
}

-(id)initWithLayer:( id )layer_
{
    if ( self = [ super initWithLayer: layer_ ] )
    {
        if ( [ layer_ isKindOfClass: [ ILAxisValueLayer class ] ] )
        {
            ILAxisValueLayer* other_ = (SCAxisValueLayer*)layer_;

            self.text          = other_.text;
            self.font          = other_.font;
            self.rotationAngle = other_.rotationAngle;
		}
	}
	return self;
}


-(void)setFont:( UIFont* )font_
{
    if ( font_ != self->_font )
    {
        self->_font = font_;
        [ self setNeedsDisplay ];
    }
}

-(void)setText:( NSString* )text_
{
    if ( ![ text_ isEqualToString: self->_text ] )
    {
        self->_text = text_;
        [ self setNeedsDisplay ];
    }
}

-(void)setRotationAngle:( CGFloat )rotationAngle_
{
    if ( rotationAngle_ != self->_rotationAngle )
    {
        self->_rotationAngle = rotationAngle_;
        self.affineTransform = CGAffineTransformIdentity;
        self.affineTransform = CGAffineTransformMakeRotation( self.rotationAngle );

        [ self setNeedsDisplay ];
    }
}

-(void)setFrame:( CGRect )frame_
{
    if ( !CGRectEqualToRect( CGRectIntegral( self.frame ), CGRectIntegral( frame_ ) ) )
    {
        if ( self->_rotationAngle != 0.0 )
        {
            self.affineTransform = CGAffineTransformIdentity;
            self.rotationAngle = 0.f;
        }

        [ super setFrame: frame_ ];
        [ self setNeedsDisplay ];
    }
}

-(void)drawInContext:( CGContextRef )context_
{
    UIGraphicsPushContext( context_ );

    [ self.text drawAtPoint: CGPointMake( 0.0, 0.0) withFont: self.font ];

    UIGraphicsPopContext();
}

-(CALayer *)hitTest:( CGPoint )point_
{
    CALayer* hitLayer_ = [ super hitTest: point_ ];
    
    return hitLayer_ == self ? nil : hitLayer_;
}

@end
