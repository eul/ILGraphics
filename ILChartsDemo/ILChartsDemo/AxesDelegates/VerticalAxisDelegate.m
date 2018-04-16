#import "VerticalAxisDelegate.h"

@implementation VerticalAxisDelegate

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

    return [NSString stringWithFormat: @"W%.02d%'%d", [result weekOfYear], [result year] % 100];
}

- (void)axis:(ILAxis *)axis didTapPoint:(NSInteger)point
{
    
}

- (CGFloat)labelsRotationAngleInDegreesForAxis:(ILAxis *)axis
{
    return 0;
}

- (UIColor *)axis:(ILAxis *)axis colorForLabelAtPoint:(NSInteger)point {

    return [UIColor whiteColor];
}

@end
