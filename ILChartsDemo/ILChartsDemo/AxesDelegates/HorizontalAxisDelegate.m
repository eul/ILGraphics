#import "HorizontalAxisDelegate.h"

@implementation HorizontalAxisDelegate

- (NSInteger)numberOfPointsForAxis:(ILAxis *)axis
{
    return 40;
}

- (NSString *)axis:(ILAxis *)axis labelTextForPoint:(NSInteger)point
{
    NSCalendar *cal = [[NSCalendar alloc ] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate     *now = [NSDate new];
    
    NSDateComponents *com = [NSDateComponents new];
    
    [com setWeekOfYear: point];
    
    NSDate *pointDate = [cal dateByAddingComponents: com
                                             toDate: now
                                            options: 0];
    
    NSDateComponents *result = [cal components: NSYearCalendarUnit | NSWeekOfYearCalendarUnit
                                      fromDate: pointDate];

    NSLog([NSString stringWithFormat: @"W%.02d%'%d", [result weekOfYear], [result year] % 100]);
    return [NSString stringWithFormat: @"W%.02d%'%d", [result weekOfYear], [result year] % 100];
}

- (BOOL)useCenteredOffsetForAxis:(ILAxis *)axis
{
    return YES;
}

- (CGFloat)labelsRotationAngleInDegreesForAxis:(ILAxis *)axis
{
    return 45.f;
}

@end
