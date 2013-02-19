#import <Foundation/Foundation.h>

@class ILVerticalAxisLayer;

@interface ILVerticalAxisLayerCalculator : NSObject

@property (nonatomic, weak    ) ILVerticalAxisLayer *axisLayer;
@property (nonatomic          ) CGFloat              heightOffset;
@property (nonatomic          ) NSInteger            divisionsCount;
@property (nonatomic, readonly) CGFloat              divisionsStep;

- (void)resetState;

- (BOOL)canDrawElementWithSize:(CGSize)elementSize
                   atYPosition:(CGFloat)yPosition;

- (CGFloat)yPositionAtIndex:(NSUInteger)index;
- (NSUInteger)indexByYPosition:(CGFloat)yPosition;

- (CGPoint)positionForValueAtIndex:(NSUInteger)index
                      withTextSize:(CGSize)textSize;

@end
