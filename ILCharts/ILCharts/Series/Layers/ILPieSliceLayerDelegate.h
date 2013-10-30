#import <Foundation/Foundation.h>

@class ILPieSliceLayer;

@protocol ILPieSliceLayerDelegate <NSObject>

- (CGRect)sliceLayer:(ILPieSliceLayer *)sliceLayer
bestRectForDrawValueInRect:(CGRect)rect;

- (void)sliceLayer:(ILPieSliceLayer *)sliceLayer
didDrawValueInRect:(CGRect)rect;

@end
