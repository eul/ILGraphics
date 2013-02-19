#import "ILBarLayer.h"

#import "ILBarState.h"

static const NSString* _animatedPropertiesNames = @"value horizontal showValue fillColor valueText frame position bounds";


//CGAffineTransformRotate( CGAffineTransformMake( 1.f, 0.f, 0.f, -1.f, 0.f, 0.f ), (float)M_PI / 2.f );
static const CGAffineTransform INVERT_Y_AND_ROTATE = 
{
      0.f, -1.f, //0
     -1.f,  0.f, //0
      0.f,  0.f  //1
};

@implementation SCBarLayer

@dynamic value, horizontal, showValue, valueText, fillColor;

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer: layer])
    {
        if ([layer isKindOfClass: [ILBarLayer class]])
        {
            ILBarLayer *other = (ILBarLayer *)layer;

            self.useAnimation      = other.useAnimation;
            self.value             = other.value;
            self.fillColor         = other.fillColor;
            self.horizontal        = other.horizontal;
            self.showValue         = other.showValue;
            self.valueText         = other.valueText;
            self.valuesFont        = other.valuesFont;
            self.drawBarBorder     = other.drawBarBorder;
            self.drawGradient      = other.drawGradient;
            self.barBorderColor    = other.barBorderColor;
            self.barBorderWidth    = other.barBorderWidth;
            self.valueTextColor    = other.valueTextColor;
            self.gradient          = other.gradient;
            self.roundCornerRadius = other.roundCornerRadius;
		}
	}    
	return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.value             = MAXFLOAT;
        self.backgroundColor   = [UIColor clearColor].CGColor;
        self.roundCornerRadius = 3.f;
    }

    return self;
}

- (void)setupWithBarState:(ILBarState *)state
                 animated:(BOOL)animated
{
    self.useAnimation   = animated;

    self.value          = state.value;
    self.frame          = state.frame;
    self.horizontal     = state.horizontal;
    self.fillColor      = state.fillColor;
    self.drawBarBorder  = state.drawBarBorder;
    self.drawGradient   = state.drawGradient;
    self.barBorderWidth = state.barBorderWidth;
    self.barBorderColor = state.barBorderColor;
    self.gradient       = state.gradient;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
    if (!self.useAnimation)
        return nil;

	if ([_animatedPropertiesNames rangeOfString: event].length > 0 )
    {
		return [self makeAnimationForKey: event];
	}

	return [super actionForKey: event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([_animatedPropertiesNames rangeOfString: key].length > 0)
    {
		return YES;
	}

	return [super needsDisplayForKey: key];
}

- (CABasicAnimation *)makeAnimationForKey:(NSString *)key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: key];

    animation.fromValue      = [[self presentationLayer] valueForKey: key];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	animation.duration       = 0.25f;

	return animation;
}

///EUL code duplicate from SCBarsSeriesCalculator
- (CGRect)barRect
{
    CGRect result = CGRectZero;

    if (!self.horizontal)
    {
        result = CGRectMake
        (
         self.bounds.origin.x, 
         self.bounds.size.height - self.bounds.size.height * self.value, 
         self.bounds.size.width, 
         self.bounds.size.height * self.value
         );
    }
    else
    {
        result = CGRectMake
        (
         self.bounds.origin.x, 
         self.bounds.origin.y,
         self.bounds.size.width * self.value, 
         self.bounds.size.height
         );
    }
    return result;
}

#pragma mark- DrawInContext

- (void)drawInContext:(CGContextRef)context
{
    CGRect barRect = [self barRect];

    [self drawFilledRect: barRect inContext: context];

    if (self.drawBarBorder)
    {
	    [self drawBarWithRect: barRect context: context];
    }
}

- (void)drawFilledRect:(CGRect)rect inContext:(CGContextRef)context
{
    CGContextSaveGState(context);

    if (self.drawGradient)
    {
        [self context: context addBarPathWithRect: rect];

        CGContextClip(context);

        CGPoint point = !self.horizontal
                        ? CGPointMake(rect.origin.x + rect.size.width, rect.origin.y )
                        : CGPointMake(rect.origin.x , rect.origin.y + rect.size.height );

        CGContextDrawLinearGradient( context
                                    , self.gradient
                                    , rect.origin
                                    , point
                                    , kCGGradientDrawsBeforeStartLocation );
         
    }
    else
    {
        CGContextSetFillColorWithColor( context, self.fillColor.CGColor);

        CGContextFillRect(context, rect);
    }

    CGContextRestoreGState(context);
}

- (void)drawBarWithRect:(CGRect)rect context:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.barBorderWidth);
    CGContextSetStrokeColorWithColor(context, [self.barBorderColor CGColor]);
    CGContextBeginPath(context);
    
    [self context: context addBarPathWithRect: rect];

    CGContextDrawPath(context, kCGPathStroke);
}

- (void)context:(CGContextRef)context addBarPathWithRect:(CGRect)rect
{
    CGContextMoveToPoint   (context, rect.origin.x, CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + self.roundCornerRadius );
    CGContextAddArc        (context, rect.origin.x + self.roundCornerRadius, rect.origin.y + self.roundCornerRadius,
                            self.roundCornerRadius, (CGFloat)M_PI, (CGFloat)(M_PI + M_PI /2.f), 0 );
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - self.roundCornerRadius, rect.origin.y);
    CGContextAddArc        (context, rect.origin.x + rect.size.width - self.roundCornerRadius, rect.origin.y + self.roundCornerRadius,
                            self.roundCornerRadius,(CGFloat)(M_PI + M_PI /2.f), (CGFloat)M_PI *2 , 0 );
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextClosePath(context);
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    return hitLayer == self ? nil : hitLayer;
}

@end
