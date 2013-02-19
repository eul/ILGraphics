#import <Foundation/Foundation.h>

@class ILValuesContainerLayer;

@interface ILValuesContainerLayerCalculator : NSObject

@property (nonatomic, weak) ILValuesContainerLayer *containerLayer;

- (NSUInteger)numberOfValues;
- (CGRect)frameForValueLayerAtIndex:(NSUInteger)layerIndex;

@end
