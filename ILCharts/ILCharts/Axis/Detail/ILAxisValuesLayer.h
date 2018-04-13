
#import <Foundation/Foundation.h>
#import "ILLayer.h"

@protocol ILAxisValuesLayerDelegate;
@class ILLayer;

@interface ILAxisValuesLayer : ILLayer

@property (nonatomic, weak) id< ILAxisValuesLayerDelegate > valuesDelegate;

@end
