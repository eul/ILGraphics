#import "ILBarsSeries.h"
#import "ILBarsSeries+Private.h"
#import "ILBarsSeriesCalculator.h"
#import "ILBarsSeriesDelegate.h"

@implementation ILBarsSeries

- (NSUInteger)numberOfValuesInValuesSeries:(id< ILValuesSeries >)valuesSeries
{
    return [self.calculator numberOfValuesToDisplay];
}

- (NSString *)valuesSeries:(id< ILValuesSeries >)valuesSeries
          valueTextAtIndex:(NSUInteger)index
{
    return [self valueTextAtIndexPath: [self.calculator indexPathByIndex: index]];
}

- (NSString *)maxValueTextForValuesSeries:(id< ILValuesSeries >)valuesSeries
{
    return [self maxValueText];
}

- (UIFont *)fontForValuesTextInValuesSeries:(id< ILValuesSeries >)valuesSeries
{
    return [self valuesTextFont];
}

- (CGRect)valuesSeries:(id< ILValuesSeries >)valuesSeries frameForValueDisplayingAtIndex:(NSUInteger)valueIndex
{
    return [self.calculator frameForValueDisplayingAtIndex: valueIndex];
}

- (BOOL)shouldShowVerticalValuesTextInValuesSeries:(id< ILValuesSeries >)valuesSeries
{
    return [self.calculator shouldShowVerticalValuesText];
}

@end
