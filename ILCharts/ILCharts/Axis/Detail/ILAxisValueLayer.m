#import "ILAxisValueLayer.h"

@implementation ILAxisValueLayer

- (id<CAAction>)actionForKey:(NSString *)event
{
	return nil;
}

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer: layer])
    {
        if ([layer isKindOfClass: [ILAxisValueLayer class]])
        {
            ILAxisValueLayer *other = (ILAxisValueLayer *)layer;

            self.text          = other.text;
            self.font          = other.font;
            self.rotationAngle = other.rotationAngle;
		}
	}
	return self;
}


- (void)setFont:(UIFont *)font
{
    if (font != self->_font)
    {
        self->_font = font;
        [self setNeedsDisplay];
    }
}

- (void)setText:(NSString *)text
{
    if ( ![text isEqualToString: self->_text])
    {
        self->_text = text;
        [self setNeedsDisplay];
    }
}

- (void)setRotationAngle:(CGFloat)rotationAngle
{
    if (rotationAngle != self->_rotationAngle)
    {
        self->_rotationAngle = rotationAngle;
        self.affineTransform = CGAffineTransformIdentity;
        self.affineTransform = CGAffineTransformMakeRotation( self.rotationAngle );

        [self setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    if ( !CGRectEqualToRect(CGRectIntegral(self.frame), CGRectIntegral(frame)))
    {
        if (self->_rotationAngle != 0.0)
        {
            self.affineTransform = CGAffineTransformIdentity;
            self.rotationAngle = 0.f;
        }

        [super setFrame: frame];
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);

    [self.text drawAtPoint: CGPointMake(0.f, 0.f) withFont: self.font];

    UIGraphicsPopContext();
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];
    
    return hitLayer == self ? nil : hitLayer;
}

@end
