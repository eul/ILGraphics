#import "ILValuesContainerLayerCalculator.h"

#import "ILValuesContainerLayer.h"
#import "ILValuesSeries.h"
#import "ILValuesSeriesDataSource.h"

@implementation ILValuesContainerLayerCalculator

- (NSUInteger)numberOfValues
{
    return [self.containerLayer.series.dataSource numberOfValuesInValuesSeries: self.containerLayer.series];
}

- (CGRect)frameForValueLayerAtIndex:(NSUInteger)layerIndex
{
    return [self.containerLayer.series.dataSource valuesSeries: self.containerLayer.series
                                frameForValueDisplayingAtIndex: layerIndex];
}

@end
