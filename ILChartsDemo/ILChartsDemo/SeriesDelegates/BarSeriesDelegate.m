#import "BarSeriesDelegate.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation BarSeriesDelegate

- (NSUInteger)numberOfGroupsInBarsSeries:(ILBarsSeries *)series
{
    return 40;
}

- (NSUInteger)barsSeries:(ILBarsSeries *)barSeries numberOfBarsInGroup:(NSUInteger)groupIndex
{
    return 3;
}

- (CGFloat)barsSeries:(ILBarsSeries *)barSeries valueForBarAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.valuesDictonary)
        self.valuesDictonary = [NSMutableDictionary new];
    
    NSNumber* number = [self.valuesDictonary objectForKey: indexPath];
    
    if (!number)
    {
        number = @((double)arc4random() / ARC4RANDOM_MAX);
        [self.valuesDictonary setObject: number forKey: indexPath];
    }
    
    return number.floatValue;
}

- (UIColor *)barsSeries:(ILBarsSeries *)barSeries fillColorForBarAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 )
    {
        return [ UIColor colorWithRed:202.0 / 256.0 green:96.0 / 256.0 blue:78.0 / 256.0 alpha: 1];
    }
    else if ( indexPath.row == 1 )
    {
        return [UIColor whiteColor];
    }
    
    return [ UIColor colorWithRed:125.0 / 256.0 green:181.0 / 256.0 blue:221.0 / 256.0 alpha: 1];
}

- (NSUInteger)maxGroupSizeInBarsSeries:(ILBarsSeries *)series
{
    return 100.f;
}

- (NSString *)barsSeries:(ILBarsSeries *)barSeries valueTextAtIndexPath:( NSIndexPath *)indexPath
{
    return [NSString stringWithFormat: @"%.1f", [[self.valuesDictonary objectForKey: indexPath] floatValue]];
}

- (BOOL)respondsToUserInteractionBarsSeries:(ILBarsSeries *)barSeries
{
    return YES;
}

- (void)barsSeries:(ILBarsSeries *)barSeries didSelectBarAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelect %@", indexPath);
}

- (BOOL)barsSeries:(ILBarsSeries *)barSeries drawBarBorderForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIColor *)barsSeries:(ILBarsSeries *)barSeries borderColorForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIColor grayColor];
}

- (BOOL)barsSeries:(ILBarsSeries *)barSeries drawGradientForBarAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 1;
}

- (CGGradientRef)barsSeries:(ILBarsSeries *)barSeries gradientForBarAtIndexPath:(NSIndexPath *)indexPath
{
    static CGGradientRef gradient = nil;
    
    if ( !gradient)
    {
        CGFloat locations[]  = { 0.f, 1.0f };

        CGFloat components[ ] = { 53.0 / 256.0, 88.0 / 256.0, 208.0 / 256.0, 1.0
                                , 109.0 / 256.0, 90.0 / 256.0, 247.0 / 256.0, 1.0 };
        
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        
        gradient = CGGradientCreateWithColorComponents( rgbColorspace
                                                      , components
                                                      , locations
                                                      , sizeof ( locations ) / sizeof ( *locations ) );
        CGColorSpaceRelease( rgbColorspace);

    }
    
    return gradient;
}

@end
