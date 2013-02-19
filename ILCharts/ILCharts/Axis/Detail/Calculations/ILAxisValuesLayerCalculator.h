#import <Foundation/Foundation.h>

@class ILAxisValuesLayer;
@class ILAxisValueState;

@interface ILAxisValuesLayerCalculator : NSObject

@property (nonatomic, weak) ILAxisValuesLayer *valuesLayer;

- (ILAxisValueState *)valueStateAtIndex:(NSUInteger)index;

- (void)resetState;
- (void)refresh;

@end
