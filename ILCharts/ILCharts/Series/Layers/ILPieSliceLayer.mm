#import "ILPieSliceLayer.h"

#import "ILPieSliceLayerDelegate.h"

#import "ILChartsMath.h"
#include <algorithm>

static const CGFloat valueBackgroundBorderXOffset_ = 3.f;
static const CGFloat angleComparationEpsilon_      = 0.01f;
static const CGFloat valuesBackgroundRoundRadius_  = 3.f;
static const NSString* animatedPropertiesNames_    = @"startAngle endAngle center showValue";

@interface ILPieSliceLayer ()
{
@private
    CGGradientRef _gradient;
}

@end

@implementation ILPieSliceLayer

@dynamic startAngle, endAngle, center, showValue;

- (void)dealloc
{
    if (_gradient)
    {
        CGGradientRelease(_gradient);
    }
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.fillColor = [UIColor grayColor];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer])
    {
        if ([layer isKindOfClass:[ILPieSliceLayer class]])
        {
            ILPieSliceLayer* other = (ILPieSliceLayer *)layer;
            
            self.showValue         = other.showValue;
            self.valueText         = other.valueText;
            self.startAngle        = other.startAngle;
            self.endAngle          = other.endAngle;
            self.fillColor         = other.fillColor;
            self.center            = other.center;
            self.sliceDelegate     = other.sliceDelegate;
            self.sliceId           = other.sliceId;
            self.valuesFont        = other.valuesFont;
            self.animationDuration = other.animationDuration;
		}
	}
	return self;
}

- (CGFloat)animationDuration
{
    if (!@(_animationDuration))
    {
        _animationDuration = 0.15f;
    }
    return _animationDuration;
}

- (void)generateGradient
{
    if (_gradient)
    {
        CGGradientRelease(_gradient);
    }
    
    CGFloat locations_[]  = {0.0f, 0.7f, 0.90f, 0.95f, 0.98f, 1.0f};
    
    CGFloat red_   = 0.f;
    CGFloat green_ = 0.f;
    CGFloat blue_  = 0.f;
    
    [self.fillColor getRed: &red_ green: &green_ blue: &blue_ alpha: nil];
    
    CGFloat components_[] = { red_*1.35f, green_*1.35f, blue_*1.35f, 1.0
        , red_/1.02f, green_/1.02f, blue_/1.02f, 1.0
        , red_/1.18f, green_/1.18f, blue_/1.18f, 1.0
        , red_/1.27f, green_/1.27f, blue_/1.27f, 1.0
        , red_/1.40f, green_/1.40f, blue_/1.40f, 1.0
        , red_/1.70f, green_/1.70f, blue_/1.70f, 1.0 };
    
    
    CGColorSpaceRef rgbColorspace_ = CGColorSpaceCreateDeviceRGB();
    
    self->_gradient = CGGradientCreateWithColorComponents(rgbColorspace_
                                                          , components_
                                                          , locations_
                                                          , sizeof (locations_) / sizeof (*locations_));
    
    CGColorSpaceRelease(rgbColorspace_);
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    
    if (self.drawGradient)
    {
        [self generateGradient];
    }
}

- (CABasicAnimation *)makeAnimationForKey:(NSString *)key
{
	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath: key];
    
	animation.fromValue      = [[self presentationLayer] valueForKey: key];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
	animation.duration       = self.animationDuration;
    
	return animation;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
	if ([animatedPropertiesNames_ rangeOfString: event].length > 0)
    {
		return [self makeAnimationForKey: event];
	}
    
	return [super actionForKey: event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([animatedPropertiesNames_ rangeOfString: key].length > 0)
    {
		return YES;
	}
    
	return [super needsDisplayForKey: key];
}

- (CGFloat)radius
{
    CGFloat viewRadius = std::min(self.frame.size.width, self.frame.size.height) / 2.f;
	static const CGFloat margin = 0.2f;
	static const CGFloat koeff  = 1.f - margin;
    
	return viewRadius * koeff;
}

- (CGRect)rectForValueDrawing
{
    CGFloat midleAngle  = (self.startAngle + self.endAngle) / 2.f;
    CGFloat sliceRadius = [self radius];
    
    CGSize textSize = [self.valueText sizeWithFont: self.valuesFont];
    
    CGRect rect = CGRectZero;
    
    CGFloat radius = sliceRadius /1.5f;
    
    for (;;)
    {
        CGPoint textOrign = CGPointMake(self.center.x + radius * cosf(midleAngle)
                                       ,self.center.y + radius * sinf(midleAngle));
        
        rect = [self valueRectWithOrign:textOrign textSize:textSize];
        
        if ((radius < (sliceRadius + textSize.height))
            && [self isSliceAroundRect: rect])
        {
            break;
        }
        
        if (radius > (sliceRadius + textSize.height) && [self isSliceOutsideRect: rect])
        {
            rect = [self.sliceDelegate sliceLayer:self
                       bestRectForDrawValueInRect:rect];
            break;
        }
        
        radius += textSize.height / 4.f;
    }
    
    if (!CGRectContainsRect(self.bounds, rect))
    {
        rect = CGRectZero;
    }
    
    [self.sliceDelegate sliceLayer:self didDrawValueInRect: rect];
    
    return rect;
}

- (BOOL)isSliceAroundPoint:(CGPoint)point
{
    CGFloat angle = [ILChartsMath angleBetweenPoint: point andPoint: self.center];

    return (angle < self.endAngle && angle > self.startAngle)
           && ([ILChartsMath distanceFromPoint:self.center toPoint: point] < self.radius);
}

- (BOOL)isSliceAroundRect:(CGRect)rect
{
    return [self isSliceAroundPoint:CGPointMake(rect.origin.x                  , rect.origin.y)]
        && [self isSliceAroundPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)]
        && [self isSliceAroundPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)]
        && [self isSliceAroundPoint:CGPointMake(rect.origin.x                  , rect.origin.y + rect.size.height)];
}

- (BOOL)isSliceOutsideRect:(CGRect)rect
{
    return ![self isSliceAroundPoint:CGPointMake(rect.origin.x                  , rect.origin.y)]
        && ![self isSliceAroundPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)]
        && ![self isSliceAroundPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)]
        && ![self isSliceAroundPoint:CGPointMake(rect.origin.x                  , rect.origin.y + rect.size.height)];
}

- (CGRect)valueRectWithOrign:(CGPoint)orign textSize:(CGSize)textSize
{
    return CGRectMake(orign.x - (textSize.width + 2.f * valueBackgroundBorderXOffset_) / 2.f
                    , orign.y - textSize.height / 2.f
                    , textSize.width + 2.f * valueBackgroundBorderXOffset_
                    , textSize.height);
}

#pragma mark- DrawInContext

- (void)drawValueBackgroundInContext:(CGContextRef)context textRect:(CGRect)rect
{
    static const UIColor* backgroundColor = [UIColor colorWithRed: 0.9f green: 0.9f blue: 0.9f alpha: 0.7f];
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    
    CGFloat radius = valuesBackgroundRoundRadius_;
    
    CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint  (context, minX, midY);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawValueTextInContext:(CGContextRef)context
{
    CGRect valueRect = [self rectForValueDrawing];
    
    [self drawValueBackgroundInContext:context textRect:valueRect];
    
    UIGraphicsPushContext(context);
    
    [[UIColor blackColor] set];
    
    [self.valueText drawInRect:valueRect
                       withFont:self.valuesFont
                  lineBreakMode: NSLineBreakByWordWrapping
                      alignment: NSTextAlignmentCenter];
    
    UIGraphicsPopContext();
}

- (void)fillSliceWithContext:(CGContextRef)context
{
    if (self.drawGradient)
    {
        CGContextSaveGState(context);
        {
            CGContextClip(context);
            
            CGContextDrawRadialGradient(context
                                        , self->_gradient
                                        , self.center
                                        , 0.f
                                        , self.center
                                        , self.radius
                                        , kCGGradientDrawsAfterEndLocation);
        }
        CGContextRestoreGState(context);
    }
    else
    {
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        CGContextSetStrokeColorWithColor(context, self.fillColor.CGColor);
        
        CGContextDrawPath(context, kCGPathEOFillStroke);
    }
}

- (void)drawSliceInContext:(CGContextRef)context
{
	CGContextMoveToPoint(context, self.center.x, self.center.y);
    CGContextAddArc     (context, self.center.x, self.center.y, self.radius, self.startAngle, self.endAngle, 0);
    
    CGContextClosePath (context);
}

- (void)drawInContext:(CGContextRef)context
{
	[self drawSliceInContext: context];
    
    [self fillSliceWithContext: context];
    
    
    if (self.showValue)
    {
        [self drawValueTextInContext: context];
    }
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];
    
    return hitLayer == self ? nil : hitLayer;
}

@end

