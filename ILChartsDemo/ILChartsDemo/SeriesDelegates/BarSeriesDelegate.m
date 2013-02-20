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
        return [ UIColor redColor ];
    }
    else if ( indexPath.row == 1 )
    {
        return [ UIColor greenColor ];
    }
    
    return [ UIColor blueColor ];
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
    return [UIColor blackColor];
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
        CGFloat locations[]  = { 0.f, 0.5f, 0.5f, 1.0f };
        
        CGFloat red   = 0.f;
        CGFloat green = 0.f;
        CGFloat blue  = 0.f;
        
        [[UIColor greenColor] getRed: &red green: &green blue: &blue alpha: nil];
        
        CGFloat components[ ] = { red * 1.205f, green * 1.239f, blue * 1.239f, 1.0
            , red, green, blue, 1.0
            , red * 0.827f, green * 0.828f, blue * 0.836f, 1.0
            , red * 1.016f, green * 1.030f, blue * 1.015f, 1.0 };
        
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
