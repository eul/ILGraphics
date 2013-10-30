#import "ILChartView.h"

#import "ILAxisLayer.h"

#import "ILSeries.h"
#import "ILLayer.h"
#import "ILAxis.h"
#import "ILValuesSeries.h"
#import "ILValuesContainerLayer.h"

#import "ILInternalChartView.h"
#import "ILChartViewInternalDelegate.h"

#import "ILSeries+ChartLayer.h"

#import <QuartzCore/QuartzCore.h>

#include <objc/message.h>

#import <JFFUtils/JFFMulticastDelegate.h>
#import <JFFUI/UIView/UIView+AddSubviewAndScale.h>

@interface ILChartView () <UIScrollViewDelegate, ILInternalChartView>

@property (nonatomic, weak) UIScrollView* scrollView;
@property (nonatomic, weak) UIView*       contentView;

@property (nonatomic) JFFMulticastDelegate< ILChartViewInternalDelegate > *internalDelegate;

@end

@implementation ILChartView
{
    CGRect                  _contentViewInsets;
    UITapGestureRecognizer* _tapRecognizer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    
    if (self)
        [self initilalize];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initilalize];
}

- (void)initilalize
{
    self.internalDelegate = (JFFMulticastDelegate<ILChartViewInternalDelegate> *)[JFFMulticastDelegate new];
    
    self.clipsToBounds = YES;
    
    self.contentView.frame = [self getContentViewFrame];
    self.contentSize       = self.contentView.bounds.size;
    
    [self addGestureRecognizer: self.tapRecognizer];
}

- (void)addAxis:(id< ILAxis >)axis
{
    [ILAxisLayer addAxisLayerToChartView: self
                                     axis: axis];
    
    self.contentView.frame = [self getContentViewFrame];
}

- (void)addSeries:(id< ILSeries >)series
{
    ILLayer *layer = nil;
    if ([series respondsToSelector: @selector(chartLayer)])
    {
        layer = objc_msgSend(series, @selector(chartLayer));
    }
    
    if (!layer)
    {
        NSLog( @"!!!ERROR!!! Series: \"%@\" does not has a layer", series );
        return;
    }
    
    CGRect contentRect =
    {
        CGPointZero
        , self.scrollView.contentSize
    };
    layer.frame = contentRect;
    
    [self.scrollView.layer addSublayer: layer];
    [layer reloadData ];
}

- (void)reloadData
{
    [self reloadDataInRect:[self visibleContentRect]
                 scrolling: NO];
}

- (void)reloadDataInRect:(CGRect)rect
               scrolling:(BOOL)isScrolling
{
    [[self.scrollView.layer.sublayers arrayByAddingObjectsFromArray: self.contentView.layer.sublayers ] enumerateObjectsUsingBlock: ^( id layer, NSUInteger idx, BOOL *stop)
    {
         if (!CGRectIsEmpty(rect) && [layer respondsToSelector: @selector(reloadDataInRect:scrolling:)])
         {
             [layer reloadDataInRect: rect
                           scrolling: isScrolling];
         }
         else if ([layer respondsToSelector: @selector(reloadData)])
         {
             [layer reloadData];
         }
     }];
    
    [self.internalDelegate chartView: self
                     didScrollToRect: rect
                           scrolling: isScrolling ];
}

#pragma mark- Properties
- (CGRect *)contentViewInsetsPtr
{
    return &self->_contentViewInsets;
}

- (UIView *)contentView
{
    if ( !self->_contentView )
    {
        UIView *contentView = [[UIView alloc] initWithFrame: self.bounds];
        contentView.clipsToBounds = NO;
        [self addSubview: contentView];
        self->_contentView = contentView;
    }
    return self->_contentView;
}

- (UIScrollView *)scrollView
{
    if ( !self->_scrollView )
    {
        UIScrollView* scrollView = [ [ UIScrollView alloc ] initWithFrame: self.bounds ];
        scrollView.delegate = self;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //clip chart content here
        scrollView.clipsToBounds = YES;
        
        [self.contentView addSubviewAndScale: scrollView];
        self->_scrollView = scrollView;
    }
    return self->_scrollView;
}

- (CGSize)getContentViewSize
{
    CGFloat width  = self.bounds.size.width  - self->_contentViewInsets.origin.x - self->_contentViewInsets.size.width;
    CGFloat height = self.bounds.size.height - self->_contentViewInsets.origin.y - self->_contentViewInsets.size.height;
    CGSize result  = (CGSize){width, height};
    return result;
}

- (CGRect)getContentViewFrame
{
    CGSize size = [self getContentViewSize];
    return CGRectMake
    (
     self->_contentViewInsets.origin.x,
     self->_contentViewInsets.origin.y,
     size.width, size.height
     );
}

- (CGFloat)chartInitialVerticalOffset
{
    return self.scrollFromTop ? 0.f : self->_contentSize.height - self.contentView.bounds.size.height;
}

#pragma mark- Layout

- (void)layoutCustomSubviews
{
    self.scrollView.contentSize = self->_contentSize;
    
    CGPoint offset = { 0.f, [self chartInitialVerticalOffset]};
    self.scrollView.contentOffset = offset;
    
    self.contentView.frame = [self getContentViewFrame];
    
    for (CALayer *layer in self.scrollView.layer.sublayers)
    {
        if ( [layer isKindOfClass: [ILLayer class]])
        {
            layer.frame = CGRectMake(0.f, 0.f, self.scrollView.contentSize.width , self.scrollView.contentSize.height);
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutCustomSubviews];
}

- (void)setContentSize:(CGSize)contentSize
{
    self->_contentSize = contentSize;
    
    [self layoutCustomSubviews];
    
    [self.internalDelegate chartViewDidChangeContentSize: self];
}

- (CGRect)visibleContentRect
{
    return (CGRect){ self.scrollView.contentOffset, self.scrollView.frame.size };
}

#pragma mark- Recognizers

- (UITapGestureRecognizer *)tapRecognizer
{
    if ( !_tapRecognizer )
    {
        SEL selector = @selector(handeleTap:);
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                 action: selector];
        _tapRecognizer.cancelsTouchesInView = NO;
    }
    return _tapRecognizer;
}

- (void)handeleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint tapLocation = [recognizer locationInView: self];
        
        CALayer *tappedLayer = [self.layer hitTest: tapLocation];
        if ([tappedLayer respondsToSelector: @selector(hadleTapAtPoint:)])
        {
            CGPoint positionInLayer = [self.layer convertPoint: tapLocation toLayer: tappedLayer];
            [(ILAxisLayer*)tappedLayer hadleTapAtPoint: positionInLayer];
        }
    }
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:( UIScrollView* )scrollView_
{
    [self reloadDataInRect: [self visibleContentRect]
                 scrolling: YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

@end
