#import "ILBarsBackgroundLayer.h"

@implementation ILBarsBackgroundLayer

- (id<CAAction>)actionForKey:(NSString *)event
{
    return nil;
}

- (void)setFrame:(CGRect)newFrame
{
    if ( !CGRectEqualToRect(self.frame, newFrame))
    {
        BOOL needDisplay = !CGSizeEqualToSize( self.frame.size, newFrame.size);

        [super setFrame: newFrame];

        if (needDisplay)
            [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth           (context, 0.6f );
	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);

    CGFloat dash[] = {1.f, 4.f, 1.f, 4.f};
    CGContextSetLineDash(context, 0.0, dash, 4);
    NSUInteger stepX = 42;
    
    long linesCnt = (long)(self.frame.size.width) / stepX;
    for ( long i = 0; i <= linesCnt; ++i)
    {
        CGContextMoveToPoint   ( context, i * stepX, 0.f );
        CGContextAddLineToPoint( context, i * stepX, self.frame.size.height );
    }

    linesCnt = (long)( self.frame.size.height ) / stepX;

    for ( long i = 0; i <= linesCnt; i++ )
    {
        CGContextMoveToPoint   (context, 0                    , i *stepX);
        CGContextAddLineToPoint(context, self.frame.size.width, i *stepX);
    }

    CGContextStrokePath (context);
    CGContextSetLineDash(context, 0, NULL, 0);
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer* hitLayer = [super hitTest: point];

    return hitLayer == self ? nil : hitLayer;
}

@end
