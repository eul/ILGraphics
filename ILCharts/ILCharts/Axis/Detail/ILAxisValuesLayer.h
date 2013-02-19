#import "ILLayer.h"

#import <Foundation/Foundation.h>

@protocol ILAxisValuesLayerDelegate;

@interface ILAxisValuesLayer : ILLayer

@property (nonatomic, weak) id< ILAxisValuesLayerDelegate > valuesDelegate;

@end
