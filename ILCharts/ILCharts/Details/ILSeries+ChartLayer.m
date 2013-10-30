#import "ILSeries+ChartLayer.h"

#import "ILBarsSeries+Private.h"
#import "ILLineSeries.h"
#import "ILValuesSeries.h"

#import "ILLineLayer.h"
#import "ILBarsContainerLayer.h"
#import "ILValuesContainerLayer.h"

#import "ILPieSeries.h"
#import "ILPiesContainerLayer.h"

#import "ILBarsSeriesCalculator.h"

@implementation ILSeries (ChartLayer)

- (ILLayer *)chartLayer
{
    return nil;
}

@end

@implementation ILBarsSeries (ChartLayer)

- (ILLayer *)chartLayer
{
    ILBarsContainerLayer *layer = [[ILBarsContainerLayer alloc] initWithBarsSeries: self];

    self.calculator.barsContainerLayer = layer;

    return  layer;
}

@end

@implementation ILPieSeries (ChartLayer)

- (ILLayer *)chartLayer
{
    return  [[ILPiesContainerLayer alloc] initWithPieSeries:self];
}

@end

@implementation ILLineSeries (ChartLayer)

- (ILLayer *)chartLayer
{
    ILLineLayer *layer = [ILLineLayer new];
    layer.lineSeries = self;

    return  layer;
}

@end

@implementation ILValuesSeries (ChartLayer)

- (ILLayer *)chartLayer
{
    ILValuesContainerLayer *layer = [ILValuesContainerLayer new];
    layer.series = self;

    return  layer;
}

@end
