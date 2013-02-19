#import <Foundation/Foundation.h>

@protocol ILValuesSeries;

@protocol ILValuesSeriesDataSource <NSObject>

- (NSUInteger)numberOfValuesInValuesSeries:(id< ILValuesSeries >)valuesSeries;

- (NSString *)valuesSeries:(id< ILValuesSeries >)valuesSeries
          valueTextAtIndex:(NSUInteger)index;

- (CGRect)valuesSeries:(id< ILValuesSeries >)valuesSeries frameForValueDisplayingAtIndex:(NSUInteger)valueIndex;

- (UIFont *)fontForValuesTextInValuesSeries:(id< ILValuesSeries >)valuesSeries;

- (BOOL)shouldShowVerticalValuesTextInValuesSeries:(id< ILValuesSeries >)valuesSeries;

@end
