#import "ILValuesContainerLayer.h"

#import "ILValueLayer.h"
#import "ILValuesSeries.h"
#import "ILValuesSeriesDataSource.h"

#import "ILValuesContainerLayerCalculator.h"

@interface ILValuesContainerLayer ()

@property (nonatomic) ILValuesContainerLayerCalculator *calculator;

@end

@implementation ILValuesContainerLayer

- (void)reloadData
{
    [self updateValueLayersCount];
    [self updateValueLayers];
}

- (void)reloadDataInRect:(CGRect)rect
               scrolling:(BOOL)scrolling
{
    [self reloadData];
}

- (void)drawInContext:(CGContextRef)context
{
}

- (void)updateValueLayers
{
    UIFont *font = [self.series.dataSource fontForValuesTextInValuesSeries: self.series];

    [self.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull layer, NSUInteger idx, BOOL * _Nonnull stop) {

        ILValueLayer *valueLayer = (ILValueLayer *)layer;

        valueLayer.frame        = [self.calculator frameForValueLayerAtIndex: idx];
        valueLayer.textColor    = [UIColor blackColor];
        valueLayer.text         = [self.series.dataSource valuesSeries: self.series valueTextAtIndex: idx];
        valueLayer.font         = font;
        valueLayer.showVertical = [self.series.dataSource shouldShowVerticalValuesTextInValuesSeries: self.series];
    }];
}

- (void)updateValueLayersCount
{
    NSUInteger valueLayersCount = [self.calculator numberOfValues];

    if (valueLayersCount > self.sublayers.count)
    {
        NSUInteger sublayersCount = self.sublayers.count;
        NSUInteger deltaCount = valueLayersCount - sublayersCount;

        for (NSUInteger i = 0; i < deltaCount; ++i)
        {
            ILValueLayer *valueLayer = [ILValueLayer new];
            valueLayer.frame = [self.calculator frameForValueLayerAtIndex: sublayersCount + i];

            [self addSublayer: valueLayer];
        }
    }
    else if (valueLayersCount < self.sublayers.count)
    {
        NSUInteger deltaCount = self.sublayers.count - valueLayersCount;

        for (NSUInteger i = 0; i < deltaCount; ++i)
        {
            [self.sublayers[0] removeFromSuperlayer];
        }
    }
}

- (ILValuesContainerLayerCalculator *)calculator
{
    if ( !self->_calculator)
    {
        self->_calculator = [ILValuesContainerLayerCalculator new];
        self->_calculator.containerLayer = self;
    }
    return self->_calculator;
}

- (CALayer *)hitTest:(CGPoint)point
{
    CALayer *hitLayer = [super hitTest: point];

    return hitLayer == self ? nil : hitLayer;
}

@end
