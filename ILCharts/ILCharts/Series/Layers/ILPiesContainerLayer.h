#import "ILLayer.h"

@class ILPieSeries;

@interface ILPiesContainerLayer : ILLayer

@property (nonatomic) ILPieSeries *pieSeries;

- (instancetype)initWithPieSeries:(ILPieSeries *)series;

@end
