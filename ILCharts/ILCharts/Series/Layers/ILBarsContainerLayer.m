#import "ILBarsContainerLayer.h"

#import "ILBarsGroupLayer.h"
#import "ILBarLayer.h"

#import "ILBarsSeries+Private.h"
#import "ILBarsBackgroundLayer.h"
#import "ILBarsSeriesCalculator.h"

@interface ILBarsContainerLayer ()
@end

@implementation ILBarsContainerLayer
{
    CGRect                 _visibleRect;
    ILBarsBackgroundLayer *_backgroundLayer;
    NSInteger              _firstVisibleIndex;
    NSInteger              _lastVisibleIndex;
    BOOL                   _scrolling;
}

- (instancetype)initWithBarsSeries:(ILBarsSeries *)barsSeries
{
    self = [super init];
    if (self)
    {
        self.barsSeries = barsSeries;
        [self applySkin];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (void)reloadData
{
    [self.barsSeries.calculator resetState];
    [self updateBars];
}

- (void)reloadDataInRect:(CGRect)rect
               scrolling:(BOOL)scrolling
{
    rect.origin.x    -= rect.size.width  /2.f ;
    rect.origin.y    -= rect.size.height /2.f;
    rect.size.width  *= 2.f;
    rect.size.height *= 2.f;

    self->_visibleRect = rect;
    self->_scrolling   = scrolling;

    [self reloadData];
}

- (void)applySkin
{
    self.backgroundColor = self.barsSeries.backgroundColor.CGColor;
    self.borderWidth     = self.barsSeries.borderWidth;
    self.borderColor     = self.barsSeries.borderColor.CGColor;
}

- (void)updateBars
{
    [self updateBackgroundLayer];
    [self updateBarGroupsCount];
    [self updateBarGroups];
}

- (void)updateBackgroundLayer
{
    self.backgroundLayer.hidden = self.barsSeries.groupsCount < 1 ? YES : NO;
    self.backgroundLayer.frame = self.visibleRect;
}

- (void)updateBarGroupsCount
{
    NSUInteger groupsCount = self.barsSeries.groupsCount;
    
    self->_firstVisibleIndex = [ self.barsSeries.calculator nearestBarsGroupIndexToPoint: self->_visibleRect.origin ];
    self->_lastVisibleIndex  = [ self.barsSeries.calculator nearestBarsGroupIndexToPoint: CGPointMake( CGRectGetMaxX( self->_visibleRect ), CGRectGetMaxY( self->_visibleRect )) ];

    if (self->_firstVisibleIndex < 0)
        self->_firstVisibleIndex = 0;
    
    if (self->_lastVisibleIndex < 0 || self->_lastVisibleIndex >= (NSInteger)groupsCount)
        self->_lastVisibleIndex = (NSInteger)groupsCount;

    NSUInteger layersCount = (NSUInteger)(self->_lastVisibleIndex - self->_firstVisibleIndex);

    if (layersCount > self.sublayers.count)
    {
        NSUInteger deltaCount_ = layersCount - self.sublayers.count;
        for ( NSUInteger i = 1; i < deltaCount_ + 1; ++i )
        {
            ILBarsGroupLayer* groupLayer = [ILBarsGroupLayer new];
            groupLayer.frame = CGRectZero;

            [self addSublayer: groupLayer];
        }
    }
    else if (layersCount < self.sublayers.count)
    {
        NSUInteger deltaCount = self.sublayers.count - layersCount;

        for ( NSUInteger i = 0; i < deltaCount; ++i)
            [self.sublayers[0] removeFromSuperlayer];
    }
}

- (void)updateBarGroups
{
    NSUInteger layersCounter = 0;

    for ( NSInteger index = self->_firstVisibleIndex; index < self->_lastVisibleIndex; ++index)
    {
        CGRect layerFrame = [self.barsSeries.calculator frameForBarsGroupAtIndex: (NSUInteger)index];

        ILBarsGroupLayer *groupLayer = self.sublayers[layersCounter++];

        groupLayer.scrolling  = self->_scrolling;
        groupLayer.frame      = layerFrame;
        groupLayer.barsSeries = self.barsSeries;
        groupLayer.groupIndex = index;

        [groupLayer reloadData];
    }
}

- (CGRect)visibleRect
{
    if (CGRectIsEmpty(self->_visibleRect))
    {
        self->_visibleRect = self.bounds;
    }
    return self->_visibleRect;
}

- (ILBarsBackgroundLayer *)backgroundLayer
{
    if ( !self->_backgroundLayer )
    {
        self->_backgroundLayer       = [ILBarsBackgroundLayer layer];
        self->_backgroundLayer.frame = self.visibleRect;

        [self.superlayer addSublayer: self->_backgroundLayer];
    }
    return self->_backgroundLayer;
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    if (hitLayer == self && [self.barsSeries respondsToUserInteraction])
    {
        return self;
    }
    else
    {
        return nil;
    }

    return hitLayer;
}

- (void)hadleTapAtPoint:(CGPoint)tapPoint
{
    NSIndexPath *tapedBarIndexPath = [self.barsSeries.calculator barsIndexPathAtPoint: tapPoint];
    if (tapedBarIndexPath)
    {
        [self.barsSeries didTapBarAtIndexPath: tapedBarIndexPath];
    }
}

@end
