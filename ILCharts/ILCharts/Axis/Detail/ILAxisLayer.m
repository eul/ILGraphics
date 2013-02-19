#import "ILAxisLayer.h"

#import "SCAxis.h"
#import "SCAxisDelegate.h"
#import "SCInternalChartView.h"

#import "SCLeftVerticalAxisLayer.h"
#import "SCRightVerticalAxisLayer.h"
#import "SCRightHorizontalAxisLayer.h"
#import "SCLeftHorizontalAxisLayer.h"

#import "SCAxisValuesLayer.h"

#import "SCChartViewInternalDelegate.h"

@interface ILAxisLayer ()

@property ( nonatomic ) id< ILAxis > axis;
@property ( nonatomic, weak ) id< ILInternalChartView > chart;
@property ( nonatomic, weak ) ILAxisValuesLayer* valuesLayer;

@end

@implementation ILAxisLayer

-(id)initWithChartView:( id< ILInternalChartView > )chart_
                  axis:( id< ILAxis > )axis_
{
    self = [ super init ];

    if ( self )
    {
        self->_axis  = axis_;
        self->_chart = chart_;

        [ self initialize ];
    }

    return self;
}

-(void)initialize
{
    [ self->_chart.internalDelegate addDelegate: self ];
}

-(void)reloadData
{
    [ self.valuesLayer setNeedsDisplay ];
    [ self setNeedsDisplay ];
}

-(void)updateContentViewInsets
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(CGFloat)startOffset
{
    return 0.f;
}

-(void)hadleTapAtPoint:( CGPoint )tapPoint_
{

}

+(void)addAxisLayerToChartView:( id< ILInternalChartView > )chart_
                          axis:( id< ILAxis > )axis_
{
    Class layerClass_;
    if ( axis_.gravity == ILAxisGravityLeft
         && axis_.orientation == ILAxisOrientationVertical )
    {
        layerClass_ = [ ILLeftVerticalAxisLayer class ];
    }
    else if ( axis_.gravity == ILAxisGravityRight
              && axis_.orientation == ILAxisOrientationVertical )
    {
        layerClass_ = [ ILRightVerticalAxisLayer class ];
    }
    else if ( axis_.gravity == ILAxisGravityRight
              && axis_.orientation == ILAxisOrientationHorizontal )
    {
        layerClass_ = [ ILRightHorizontalAxisLayer class ];
    }
    else
    {
        layerClass_ = [ ILLeftHorizontalAxisLayer class ];
    }
    ILAxisLayer* layer_ = [ [ layerClass_ alloc ] initWithChartView: chart_ axis: axis_ ];

    [ layer_ updateContentViewInsets ];

    [ layer_ addSublayer: layer_.valuesLayer ];

    chart_.contentSize = [ chart_ getContentViewSize ];

    [ chart_.contentView.layer addSublayer: layer_ ];

    [ layer_ reloadData ];

    layer_.backgroundColor = [ layer_.axis.delegate respondsToSelector: @selector( backgroundColorForAxis: ) ]
                             ? [ layer_.axis.delegate backgroundColorForAxis: layer_.axis ].CGColor
                             : [ UIColor clearColor ].CGColor;
}

-(SCAxisValuesLayer*)createValuesLayer
{
    ILAxisValuesLayer* layer_ = [ ILAxisValuesLayer new ];
    layer_.frame = self.bounds;
    layer_.delegate = self;

    return layer_;
}

-(SCAxisValuesLayer*)valuesLayer
{
    if ( !self->_valuesLayer )
    {
        ILAxisValuesLayer* layer_ = [ self createValuesLayer ];
        self->_valuesLayer = layer_;
        return layer_;
    }
    return self->_valuesLayer;
}

-(CGRect)actualRectForFrame
{
    [ self doesNotRecognizeSelector: _cmd ];
    return CGRectZero;
}

-(void)updateFrame
{
    self.frame = [ self actualRectForFrame ];
    self.valuesLayer.frame = self.bounds;
}

-(void)layoutSublayers
{
    [ super layoutSublayers ];

    [ self updateFrame ];
}

-(BOOL)canDrawLineAtPoint:( CGFloat )currY_
{
    [ self doesNotRecognizeSelector: _cmd ];
    return NO;
}

-(CGFloat)shortLineStartPos
{
    [ self doesNotRecognizeSelector: _cmd ];
    return 0.f;
}

-(BOOL)useCenteredOffset
{
    return [ self.axis.delegate respondsToSelector: @selector( useCenteredOffsetForAxis: ) ]
           ? [ self.axis.delegate useCenteredOffsetForAxis: self.axis ]
           : NO;
}

-(BOOL)useCenteredOffsetForValues
{
    return [ self.axis.delegate respondsToSelector: @selector( useCenteredOffsetForValuesInAxis: ) ]
           ? [ self.axis.delegate useCenteredOffsetForValuesInAxis: self.axis ]
           : NO;
}

-(CGFloat)shortDevisionsWidth
{
    return [ self.axis.delegate respondsToSelector: @selector(shortDivisionsWidthForAxis:) ]
           ? [ self.axis.delegate shortDivisionsWidthForAxis: self.axis ]
           : 1.f;
}

-(CGFloat)shortDevisionsLength
{
    return [ self.axis.delegate respondsToSelector: @selector(shortDivisionsLengthForAxis:) ]
           ? [ self.axis.delegate shortDivisionsLengthForAxis: self.axis ]
           : 5.f;
}

-(UIColor*)shortDivisionsColor
{
    return [ self.axis.delegate respondsToSelector: @selector(shortDivisionsColorForAxis:) ]
           ? [ self.axis.delegate shortDivisionsColorForAxis: self.axis ]
           : [ UIColor grayColor ];
}

-(CGFloat)bigDivisionsLength
{
    return [ self.axis.delegate respondsToSelector: @selector(bigDivisionsLengthForAxis:) ]
           ? [ self.axis.delegate bigDivisionsLengthForAxis: self.axis ]
           : 8.f;
}

-(CGFloat)bigDivisionsWidth
{
    return [ self.axis.delegate respondsToSelector: @selector(bigDivisionsWidthForAxis:) ]
           ? [ self.axis.delegate bigDivisionsWidthForAxis: self.axis ]
           : 2.f;
}

-(UIColor*)bigDivisionsColor
{
    return [ self.axis.delegate respondsToSelector: @selector(bigDivisionsColorForAxis:) ]
           ? [ self.axis.delegate bigDivisionsColorForAxis: self.axis ]
           : [ UIColor grayColor ];
}

-(UIFont*)fontForLabelAtPoint:( NSInteger )pointIndex_
{
    return [ self.axis.delegate respondsToSelector: @selector(axis:fontForLabelAtPoint:) ]
           ? [ self.axis.delegate axis: self.axis fontForLabelAtPoint: pointIndex_ ]
           : [ UIFont fontWithName:@"Helvetica Neue" size: 10.f ];
}

-(UIColor*)colorForLabelAtPoint:( NSInteger )pointIndex_
{
    return [ self.axis.delegate respondsToSelector: @selector(axis:colorForLabelAtPoint:) ]
           ? [ self.axis.delegate axis: self.axis colorForLabelAtPoint: pointIndex_ ]
           : [ UIColor blackColor ];
}

-(CGFloat)axisWidth
{
    return [ self.axis.delegate respondsToSelector: @selector(widthForAxis:) ]
           ? [ self.axis.delegate widthForAxis: self.axis ]
           : 4.f;
}

-(UIColor*)axisColor
{
    return [ self.axis.delegate respondsToSelector: @selector(colorForAxis:) ]
           ? [ self.axis.delegate colorForAxis: self.axis ]
           : [ UIColor orangeColor ];
}

-(CGFloat)labelsRotationAngleInRadians
{
    CGFloat degrees_ = [ self.axis.delegate respondsToSelector: @selector(labelsRotationAngleInDegreesForAxis:) ]
                       ? [ self.axis.delegate labelsRotationAngleInDegreesForAxis: self.axis ]
                       : 0.f;
    return (CGFloat)M_PI * degrees_ / 180.f;
}

-(void)drawShortLinesInContext:( CGContextRef )context_
                  fromPosition:( CGFloat )y_
                          step:( CGFloat )step_
{
    if ( !self.axis.drawShortDelimiters )
        return;

    CGContextSetLineWidth( context_, [ self shortDevisionsWidth ]  );
    CGContextSetStrokeColorWithColor( context_, [ self shortDivisionsColor ].CGColor );

    CGFloat smallStep_ = step_ / 5.f;
    if ( smallStep_ < 2.f )
        return;

    for ( NSUInteger index_ = 1; index_ <= 4; ++index_ )
    {
        CGFloat currY_ = y_ - index_*smallStep_;

        CGFloat x1_ = [ self shortLineStartPos ];
        CGFloat x2_ = x1_ - [ self shortDevisionsLength ];
        CGContextMoveToPoint( context_ , x1_, currY_ );
        CGContextAddLineToPoint( context_, x2_, currY_ );
    }

    CGContextStrokePath( context_ );
}

#pragma mark- ILChartViewInternalDelegate

-(void)chartViewDidChangeContentSize:( ILChartView* )chart_
{
    [ self updateFrame ];
}

-(void)chartView:( ILChartView* )chart_
 didScrollToRect:( CGRect )visibleRect_
       scrolling:( BOOL )scrolling_
{
    [ self setNeedsDisplay ];

    [ self.valuesLayer reloadDataInRect: visibleRect_
                              scrolling: scrolling_ ];
}

#pragma mark- ILAxisValuesLayerDelegate

-(CGFloat)valueTextRotationAngleInValuesLayer:( ILAxisValuesLayer* )valuesLayer_
{
    return 0.f;
}

-(NSUInteger)numberOfValuesInValuesLayer:( ILAxisValuesLayer* )valuesLayer_
{
    return (NSUInteger)[ self.axis.delegate numberOfPointsForAxis: self.axis ] + 1;
}

-(NSString*)valuesLayer:( ILAxisValuesLayer* )valuesLayer_
    textForValueAtIndex:( NSUInteger )index_
{
    return [ self.axis.delegate axis: self.axis
                   labelTextForPoint: (NSInteger)index_ ];
}

-(UIFont*)valuesLayer:( ILAxisValuesLayer* )valuesLayer_
  fontForValueAtIndex:( NSUInteger )index_
{
    return [ self fontForLabelAtPoint: (NSInteger)index_ ];
}

-(UIColor*)valuesLayer:( ILAxisValuesLayer* )valuesLayer_
  colorForValueAtIndex:( NSUInteger )index_
{
    return [ self colorForLabelAtPoint: (NSInteger)index_ ];
}

-(CGPoint)valuesLayer:( ILAxisValuesLayer* )valuesLayer_
positionForValueAtIndex:( NSUInteger )index_
         withTextSize:(CGSize)textSize_
{
    return CGPointZero;
}

-(BOOL)isAxisVerticalForValuesLayer:( ILAxisValuesLayer* )valuesLayer_
{
    return NO;
}

-(BOOL)isAxisLeftForValuesLayer:( ILAxisValuesLayer* )valuesLayer_
{
    return NO;
}

-(BOOL)canDrawElementWithSize:( CGSize )elementSize_
                      atPoint:( CGPoint )point_
{
    return YES;
}

-(NSInteger)nearestValueIndexToPoint:( CGPoint )point_
{
    return -1;
}

@end
