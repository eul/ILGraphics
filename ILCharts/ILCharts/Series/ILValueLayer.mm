#import "ILValueLayer.h"

static const NSString* _animatedPropertiesNames = @"text font textColor showVertical";
static const CGFloat valuesBackgroundRoundRadius_  = 2.f;

static const CGAffineTransform INVERT_Y_AND_ROTATE = 
{
     0.f, -1.f, //0
    -1.f,  0.f, //0
     0.f,  0.f  //1
};

@implementation ILValueLayer

@dynamic text, font, textColor, showVertical;

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer: layer])
    {
        if ([layer isKindOfClass: [ILValueLayer class]])
        {
            ILValueLayer *other = (ILValueLayer *)layer;

            self.text         = other.text;
            self.font         = other.font;
            self.textColor    = other.textColor;
            self.showVertical = other.showVertical;
		}
	}    
	return self;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
	if ([_animatedPropertiesNames rangeOfString: event].length > 0 )
    {
		return [self makeAnimationForKey: event];
	}

	return nil;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
	return YES;
}

- (CABasicAnimation *)makeAnimationForKey:(NSString *)key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: key];

    animation.fromValue      = [[self presentationLayer ] valueForKey: key];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	animation.duration       = 0.25f;

	return animation;
}

- (void)drawInContext:(CGContextRef)context
{
    [self drawBackgroundInContext: context];

    [self drawTextInContext: context];
}

- (void)drawBackgroundInContext:(CGContextRef)context
{
    static const UIColor *backgroundColor = [UIColor colorWithRed: 0.9f green: 0.9f blue: 0.9f alpha: 0.7f];

    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);

    CGFloat radius = valuesBackgroundRoundRadius_;

    CGFloat minX = CGRectGetMinX(self.bounds), midX = CGRectGetMidX(self.bounds), maxX = CGRectGetMaxX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds), midY = CGRectGetMidY(self.bounds), maxY = CGRectGetMaxY(self.bounds);

    CGContextMoveToPoint  (context, minX, midY );
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawTextInContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);

    [self.textColor set];

    if (!self.showVertical)
    {
        CGRect rect = self.bounds;

        #if __clang_major__ >= 4
        [ self.text drawInRect: rect
                      withFont: self.font
                 lineBreakMode: NSLineBreakByWordWrapping//NSLineBreakByWordWrapping
                     alignment: NSTextAlignmentCenter//NSTextAlignmentCenter
         ];
        #else
        [ self.text drawInRect: rect
                      withFont: self.font
                 lineBreakMode: UILineBreakModeWordWrap
                     alignment: UITextAlignmentCenter
         ];
        #endif
    }
    else
    {
        CGContextSaveGState(context);

        CGContextSetTextMatrix(context, INVERT_Y_AND_ROTATE );

        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextSelectFont(context, [self.font.fontName UTF8String] , self.font.pointSize, kCGEncodingMacRoman);

        CGContextShowTextAtPoint(context
                                 , self.bounds.origin.x + (int)self.bounds.size.width / 2 + 3.5f
                                 , self.bounds.origin.y + (int)self.bounds.size.height - 3.f
                                 , [ self.text cStringUsingEncoding: NSUTF8StringEncoding ]
                                 , [ self.text length ] );

        CGContextRestoreGState(context);

        CGContextSetTextMatrix(context, CGAffineTransformIdentity );
    }
    UIGraphicsPopContext();
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    return hitLayer == self ? nil : hitLayer;
}
@end
