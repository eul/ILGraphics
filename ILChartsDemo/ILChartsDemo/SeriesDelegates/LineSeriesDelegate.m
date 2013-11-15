#import "LineSeriesDelegate.h"

#define ARC4RANDOM_MAX      0x100000000

#define VALUES_CNT 30

@implementation LineSeriesDelegate
{
    NSMutableArray *_values;
}

- (NSArray *)values
{
    if (!_values) {
        _values = [NSMutableArray new];
        for (NSUInteger i=0 ;i<VALUES_CNT; ++i)
            [_values addObject:@((double)arc4random() / ARC4RANDOM_MAX)];
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
    return [UIColor blueColor];
}

@end
