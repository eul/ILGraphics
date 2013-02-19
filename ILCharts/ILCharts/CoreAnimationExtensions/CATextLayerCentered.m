#import "CATextLayerCentered.h"

@implementation CATextLayerCentered

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat height   = self.frame.size.height;
    CGFloat fontSize = self.fontSize;

    
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGFloat offset = (height - fontSize)/2.f + 1.f;
#else
    CGFloat offset = (fontSize-height)/2.f - 1.f;     // negative
#endif    
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM( ctx, 0.f, offset );
    [ super drawInContext:ctx ];
    CGContextRestoreGState(ctx);
}

@end
