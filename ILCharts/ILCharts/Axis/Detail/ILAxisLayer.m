#import "ILAxisLayer.h"

#import "ILAxis.h"
#import "ILAxisDelegate.h"
#import "ILInternalChartView.h"

#import "ILLeftVerticalAxisLayer.h"
#import "ILRightVerticalAxisLayer.h"
#import "ILRightHorizontalAxisLayer.h"
#import "ILLeftHorizontalAxisLayer.h"

#import "ILAxisValuesLayer.h"

#import "ILChartViewInternalDelegate.h"

@interface ILAxisLayer ()

@property (nonatomic) id< ILAxis > axis;
@property (nonatomic, weak) id< ILInternalChartView > chart;
@property (nonatomic, weak) ILAxisValuesLayer *valuesLayer;

@end

@implementation ILAxisLayer

- (id)initWithChartView:(id< ILInternalChartView >)chart
                   axis:(id< ILAxis >)axis
{
    self = [super init];

    if (self)
    {
        self->_axis  = axis;
        self->_chart = chart;

        [self initialize];
    }

    return self;
}

- (void)initialize
{
    [self->_chart.internalDelegate addDelegate: self];
}

- (void)reloadData
{
    [self.valuesLayer setNeedsDisplay];
    [self setNeedsDisplay];
}

- (void)updateContentViewInsets
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-( CGFloat)startOffset
{
    return 0.f;
}

- (void)hadleTapAtPoint:(CGPoint)tapPoint
{

}

+ (void)addAxisLayerToChartView:(id< ILInternalChartView >)chart
                           axis:(id< ILAxis >)axis
{
    Class layerClass;
    if (axis.gravity == ILAxisGravityLeft
         && axis.orientation == ILAxisOrientationVertical)
    {
        layerClass = [ ILLeftVerticalAxisLayer class ];
    }
    else if (axis.gravity == ILAxisGravityRight
              && axis.orientation == ILAxisOrientationVertical)
    {
        layerClass = [ILRightVerticalAxisLayer class];
    }
    else if ( axis.gravity == ILAxisGravityRight
              && axis.orientation == ILAxisOrientationHorizontal)
    {
        layerClass = [ILRightHorizontalAxisLayer class];
    }
    else
    {
        layerClass = [ILLeftHorizontalAxisLayer class];
    }
    ILAxisLayer *layer = [[layerClass alloc] initWithChartView: chart axis: axis];

    [layer updateContentViewInsets];

    [layer addSublayer: layer.valuesLayer];

    chart.contentSize = [chart getContentViewSize];

    [chart.contentView.layer addSublayer: layer];

    [layer reloadData];

    layer.backgroundColor = [layer.axis.delegate respondsToSelector: @selector(backgroundColorForAxis:)]
                            ? [layer.axis.delegate backgroundColorForAxis: layer.axis].CGColor
                            : [UIColor clearColor ].CGColor;
}

- (ILAxisValuesLayer *)createValuesLayer
{
    ILAxisValuesLayer *layer = [ILAxisValuesLayer new];
    layer.frame = self.bounds;
    layer.delegate = self;

    return layer;
}

- (ILAxisValuesLayer *)valuesLayer
{
    if (!self->_valuesLayer)
    {
        ILAxisValuesLayer *layer = [self createValuesLayer];
        self->_valuesLayer = layer;
        return layer;
    }
    return self->_valuesLayer;
}

- (CGRect)actualRectForFrame
{
    [self doesNotRecognizeSelector: _cmd];
    return CGRectZero;
}

- (void)updateFrame
{
    self.frame = [self actualRectForFrame];
    self.valuesLayer.frame = self.bounds;
}

- (void)layoutSublayers
{
    [super layoutSublayers];

    [self updateFrame];
}

- (BOOL)canDrawLineAtPoint:(CGFloat)currY
{
    [ self doesNotRecognizeSelector: _cmd ];
    return NO;
}

- (CGFloat)shortLineStartPos
{
    [ self doesNotRecognizeSelector: _cmd ];
    return 0.f;
}

- (BOOL)useCenteredOffset
{
    return [self.axis.delegate respondsToSelector: @selector(useCenteredOffsetForAxis:)]
           ? [self.axis.delegate useCenteredOffsetForAxis: self.axis]
           : NO;
}

- (BOOL)useCenteredOffsetForValues
{
    return [self.axis.delegate respondsToSelector: @selector(useCenteredOffsetForValuesInAxis:)]
           ? [self.axis.delegate useCenteredOffsetForValuesInAxis: self.axis]
           : NO;
}

- (CGFloat)shortDevisionsWidth
{
    return [self.axis.delegate respondsToSelector: @selector(shortDivisionsWidthForAxis:)]
           ? [self.axis.delegate shortDivisionsWidthForAxis: self.axis]
           : 1.f;
}

- (CGFloat)shortDevisionsLength
{
    return [self.axis.delegate respondsToSelector: @selector(shortDivisionsLengthForAxis:)]
           ? [self.axis.delegate shortDivisionsLengthForAxis: self.axis]
           : 5.f;
}

- (UIColor *)shortDivisionsColor
{
    return [self.axis.delegate respondsToSelector: @selector(shortDivisionsColorForAxis:)]
           ? [self.axis.delegate shortDivisionsColorForAxis: self.axis]
           : [UIColor grayColor];
}

- (CGFloat)bigDivisionsLength
{
    return [self.axis.delegate respondsToSelector: @selector(bigDivisionsLengthForAxis:)]
           ? [self.axis.delegate bigDivisionsLengthForAxis: self.axis]
           : 8.f;
}

- (CGFloat)bigDivisionsWidth
{
    return [self.axis.delegate respondsToSelector: @selector(bigDivisionsWidthForAxis:)]
           ? [self.axis.delegate bigDivisionsWidthForAxis: self.axis]
           : 2.f;
}

- (UIColor *)bigDivisionsColor
{
    return [self.axis.delegate respondsToSelector: @selector(bigDivisionsColorForAxis:)]
           ? [self.axis.delegate bigDivisionsColorForAxis: self.axis]
           : [UIColor grayColor];
}

- (UIFont *)fontForLabelAtPoint:(NSInteger)pointIndex
{
    return [self.axis.delegate respondsToSelector: @selector(axis:fontForLabelAtPoint:)]
           ? [self.axis.delegate axis: self.axis fontForLabelAtPoint: pointIndex]
           : [UIFont fontWithName:@"Helvetica Neue" size: 10.f];
}

- (UIColor *)colorForLabelAtPoint:(NSInteger)pointIndex
{
    return [self.axis.delegate respondsToSelector: @selector(axis:colorForLabelAtPoint:)]
           ? [self.axis.delegate axis: self.axis colorForLabelAtPoint: pointIndex]
           : [UIColor blackColor];
}

- (CGFloat)axisWidth
{
    return [self.axis.delegate respondsToSelector: @selector(widthForAxis:)]
           ? [self.axis.delegate widthForAxis: self.axis]
           : 4.f;
}

- (UIColor *)axisColor
{
    return [self.axis.delegate respondsToSelector: @selector(colorForAxis:)]
           ? [self.axis.delegate colorForAxis: self.axis]
           : [UIColor orangeColor];
}

- (CGFloat)labelsRotationAngleInRadians
{
    CGFloat degrees = [self.axis.delegate respondsToSelector: @selector(labelsRotationAngleInDegreesForAxis:)]
                      ? [self.axis.delegate labelsRotationAngleInDegreesForAxis: self.axis]
                      : 0.f;
    return (CGFloat)M_PI * degrees /180.f;
}

- (void)drawShortLinesInContext:(CGContextRef)context
                   fromPosition:(CGFloat)y
                           step:(CGFloat)step
{
    if (!self.axis.drawShortDelimiters)
        return;

    CGContextSetLineWidth(context, [self shortDevisionsWidth]);
    CGContextSetStrokeColorWithColor(context, [self shortDivisionsColor].CGColor);

    CGFloat smallStep = step /5.f;
    if (smallStep < 2.f)
        return;

    for (NSUInteger index = 1; index <= 4; ++index)
    {
        CGFloat currY = y - index *smallStep;

        CGFloat x1 = [self shortLineStartPos];
        CGFloat x2 = x1 - [self shortDevisionsLength];
        
        CGContextMoveToPoint(context , x1, currY);
        CGContextAddLineToPoint(context, x2, currY);
    }

    CGContextStrokePath(context);
}

#pragma mark- ILChartViewInternalDelegate

- (void)chartViewDidChangeContentSize:(ILChartView *)chart
{
    [self updateFrame];
}

- (void)chartView:(ILChartView *)chart
  didScrollToRect:(CGRect)visibleRect
        scrolling:(BOOL)scrolling
{
    [self setNeedsDisplay];

    [self.valuesLayer reloadDataInRect: visibleRect
                             scrolling: scrolling];
}

#pragma mark- ILAxisValuesLayerDelegate

- (CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return 0.f;
}

- (NSUInteger)numberOfValuesInValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return (NSUInteger)[self.axis.delegate numberOfPointsForAxis: self.axis] + 1;
}

- (NSString *)valuesLayer:(ILAxisValuesLayer *)valuesLayer
      textForValueAtIndex:(NSUInteger)index
{
    return [self.axis.delegate axis: self.axis
                  labelTextForPoint: (NSInteger)index];
}

- (UIFont *)valuesLayer:(ILAxisValuesLayer *)valuesLayer
    fontForValueAtIndex:(NSUInteger)index
{
    return [self fontForLabelAtPoint: (NSInteger)index];
}

- (UIColor *)valuesLayer:(ILAxisValuesLayer *)valuesLayer
    colorForValueAtIndex:(NSUInteger)index
{
    return [self colorForLabelAtPoint:(NSInteger)index];
}

- (CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer
positionForValueAtIndex:(NSUInteger)index
           withTextSize:(CGSize)textSize
{
    return CGPointZero;
}

- (BOOL)isAxisVerticalForValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return NO;
}

- (BOOL)isAxisLeftForValuesLayer:(ILAxisValuesLayer *)valuesLayer
{
    return NO;
}

- (BOOL)canDrawElementWithSize:(CGSize)elementSize
                       atPoint:(CGPoint)point
{
    return YES;
}

- (NSInteger)nearestValueIndexToPoint:(CGPoint)point
{
    return -1;
}

@end
