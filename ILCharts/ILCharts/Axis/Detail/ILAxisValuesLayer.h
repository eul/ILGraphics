#import "ILLayer.h"
#import <QuartzCore/QuartzCore.h>

#import <Foundation/Foundation.h>

@protocol ILAxisValuesLayerDelegate;

@interface ILAxisValuesLayer : ILLayer

@property ( nonatomic, weak ) id< ILAxisValuesLayerDelegate > valuesDelegate;

@end
