#import "LineSeriesDelegate.h"

#define ARC4RANDOM_MAX 0x100000000

#define VALUES_CNT 900

@implementation LineSeriesDelegate
{
    NSMutableArray *_values;
}

- (NSArray *)values
{
    if (!_values) {
        _values = [NSMutableArray new];
        for (NSUInteger i=0 ;i<VALUES_CNT; ++i)
            [_values addObject:@(sin(i / 10.f)/4.f + 0.5f)];
    }
    return _values;
}

- (void)refreshData
{
    _values = nil;
}

#pragma mark- ILLineSeriesDelegate

- (NSInteger)numberOfElementsForLineSeries:(ILLineSeries *)series
{
    return VALUES_CNT;
}

- (float)lineSeries:(ILLineSeries *)series
       valueAtIndex:(NSUInteger)index
{
    return [[self values][index] floatValue];
}

- (UIColor*)colorForLineSeries:(ILLineSeries *)series
{
    return [UIColor colorWithRed: 96.0 / 256.0 green:151.0 / 256.0 blue:252.0 / 256.0 alpha: 1];
}

@end
