#import "ILBarsGroupLayer.h"

#import "ILBarsSeries+Private.h"

#import "ILBarLayer.h"
#import "ILBarState.h"
#import "ILBarsSeriesCalculator.h"

@implementation ILBarsGroupLayer
{
    CGFloat _barSize;
    BOOL    _useAnimation;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)reloadData
{
    [self updateInnerState];
    [self updateBarsLayersCount];
    [self updateBarsLayers];
}

- (id<CAAction>)actionForKey:(NSString *)event
{
    if ( ! self->_useAnimation || self->_scrolling )
        return nil;

	return [super actionForKey: event];
}

- (void)updateInnerState
{
   self->_useAnimation = [self.barsSeries useAnimation];
}

- (void)updateBarsLayers
{
    [self.sublayers enumerateObjectsUsingBlock:^(ILBarLayer *barLayer, NSUInteger index, BOOL *stop)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: (NSInteger)index inSection: (NSInteger)self.groupIndex];

        [barLayer setupWithBarState: [self.barsSeries.calculator stateForBarAtIndexPath: indexPath]
                           animated: self.scrolling ? NO : self->_useAnimation];
    } ];
}

- (void)updateBarsLayersCount
{
    NSUInteger barsCount = [self.barsSeries numberOfBarsInGroup: self.groupIndex];

    if (barsCount > self.sublayers.count)
    {
        NSUInteger deltaCount = barsCount - self.sublayers.count;
		for ( NSUInteger i = 1; i < deltaCount + 1; ++i )
        {
			ILBarLayer *barLayer = [ILBarLayer new];

			[self addSublayer: barLayer];
		}
	}
	else if (barsCount < self.sublayers.count)
    {
		NSUInteger deltaCount = self.sublayers.count - barsCount;

		for ( NSUInteger i = 0; i < deltaCount; ++i )
            [self.sublayers[0] removeFromSuperlayer];
	}
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    return hitLayer == self ? nil : hitLayer;
}

@end
