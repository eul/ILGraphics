#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ILAxisValuesLayer;

@protocol ILAxisValuesLayerDelegate <NSObject>

@required
- (CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer;

- (NSUInteger)numberOfValuesInValuesLayer:(ILAxisValuesLayer *)valuesLayer;

- (NSString*)valuesLayer:(ILAxisValuesLayer *)valuesLayer
     textForValueAtIndex:(NSUInteger)index;

- (UIFont *)valuesLayer:(ILAxisValuesLayer *)valuesLayer
    fontForValueAtIndex:(NSUInteger)index;

- (UIColor *)valuesLayer:(ILAxisValuesLayer *)valuesLayer
    colorForValueAtIndex:(NSUInteger)index;

- (CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer
positionForValueAtIndex:(NSUInteger)index
           withTextSize:(CGSize)textSize;

- (NSInteger)nearestValueIndexToPoint:(CGPoint)point;

- (BOOL)isAxisVerticalForValuesLayer:(ILAxisValuesLayer *)valuesLayer;
- (BOOL)isAxisLeftForValuesLayer:(ILAxisValuesLayer *)valuesLayer;

- (BOOL)canDrawElementWithSize:(CGSize)elementSize
                       atPoint:(CGPoint)point;

@end
