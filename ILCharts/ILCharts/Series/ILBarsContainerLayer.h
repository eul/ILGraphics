#import "ILLayer.h"

#import <QuartzCore/QuartzCore.h>

@class ILBarsSeries;

@interface ILBarsContainerLayer : ILLayer

@property (nonatomic) ILBarsSeries *barsSeries;

- (id)initWithBarsSeries:(ILBarsSeries *)barsSeries;

@end
