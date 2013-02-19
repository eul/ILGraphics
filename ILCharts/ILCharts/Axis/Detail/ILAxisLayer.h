#import <QuartzCore/QuartzCore.h>

#import "ILAxisValuesLayerDelegate.h"

@protocol ILAxis
, ILInternalChartView;

@interface ILAxisLayer : CALayer < ILAxisValuesLayerDelegate >

@property ( nonatomic, readonly       ) id< ILAxis >              axis;
@property ( nonatomic, readonly, weak ) id< ILInternalChartView > chart;
@property ( nonatomic, readonly       ) CGFloat                   startOffset;

+(void)addAxisLayerToChartView:( id< ILInternalChartView > )chart_
                          axis:( id< ILAxis > )axis_;

-(id)initWithChartView:( id< ILInternalChartView > )chart_
                  axis:( id< ILAxis > )axis_;

-(void)initialize;

-(void)reloadData;

-(void)hadleTapAtPoint:( CGPoint )tapPoint_;

//draw

-(void)drawShortLinesInContext:( CGContextRef )context_
                  fromPosition:( CGFloat )y_
                          step:( CGFloat )step_;

-(BOOL)useCenteredOffset;
-(BOOL)useCenteredOffsetForValues;
-(CGFloat)shortDevisionsWidth;
-(CGFloat)shortDevisionsLength;
-(UIColor*)shortDivisionsColor;
-(CGFloat)bigDivisionsLength;
-(CGFloat)bigDivisionsWidth;
-(UIColor*)bigDivisionsColor;
-(CGFloat)axisWidth;
-(UIColor*)axisColor;
-(CGFloat)labelsRotationAngleInRadians;
-(UIFont*)fontForLabelAtPoint:( NSInteger )pointIndex_;
-(UIColor*)colorForLabelAtPoint:( NSInteger )pointIndex_;

@end
