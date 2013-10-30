#import "PieSeriesDelegate.h"

@implementation PieSeriesDelegate
{
    NSMutableArray *_piesData;
    NSArray        *_colorData;
}

- (void)refreshData
{
    NSUInteger total           = 0;
    NSUInteger maxValue        = 100;
    NSUInteger currentPieValue = 0;
    
    _piesData = [NSMutableArray new];
    
    do {
        currentPieValue = arc4random() % maxValue;
        
        if ((total + currentPieValue) > maxValue) {
            break;
        }

        total += currentPieValue;
        
        [_piesData addObject:@(currentPieValue)];

    } while (YES);
    
    [_piesData addObject:@(maxValue - total)];
}

- (NSArray *)colorData
{
    if (!_colorData){
        _colorData = @[[UIColor redColor],     [UIColor greenColor],  [UIColor blueColor],    [UIColor blackColor],     [UIColor brownColor],
                       [UIColor grayColor],    [UIColor yellowColor], [UIColor darkGrayColor],[UIColor lightGrayColor], [UIColor cyanColor],
                       [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor]];
    }
    return _colorData;
}

#pragma mark- ILPieSeriesDelegate

- (NSUInteger)numberOfElementsForPieChartSeries:(ILPieSeries *)series
{
    if (!_piesData)
        [self refreshData];

    return _piesData.count;
}

- (float)pieChartSeries:(ILPieSeries *)series
           valueAtIndex:(NSUInteger)index
{
    return [_piesData[index] floatValue];
}

- (UIColor *)pieChartSeries:(ILPieSeries *)series
               colorAtIndex:(NSUInteger)index
{
    return self.colorData[arc4random() %_colorData.count];
}

- (BOOL)shouldShowValuesForPieChartSeries:(ILPieSeries *)series
{
    return YES;
}

- (CGFloat)startAngleInRadiansForPieChartSeries:(ILPieSeries *)series
{
    return 0.f;
}

@end
