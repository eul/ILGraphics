#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ILAxisValuesLayer;

@protocol ILAxisValuesLayerDelegate <NSObject>

@required
-(CGFloat)valueTextRotationAngleInValuesLayer:(ILAxisValuesLayer *)valuesLayer_;

-(NSUInteger)numberOfValuesInValuesLayer:(ILAxisValuesLayer *)valuesLayer_;

-(NSString*)valuesLayer:(ILAxisValuesLayer *)valuesLayer_
    textForValueAtIndex:(NSUInteger )index_;

-(UIFont*)valuesLayer:(ILAxisValuesLayer *)valuesLayer_
  fontForValueAtIndex:(NSUInteger )index_;

-(UIColor*)valuesLayer:(ILAxisValuesLayer *)valuesLayer_
  colorForValueAtIndex:(NSUInteger )index_;

-(CGPoint)valuesLayer:(ILAxisValuesLayer *)valuesLayer_
positionForValueAtIndex:(NSUInteger )index_
           withTextSize:(CGSize )textSize_;

-(NSInteger)nearestValueIndexToPoint:( CGPoint )point_;

-(BOOL)isAxisVerticalForValuesLayer:(ILAxisValuesLayer *)valuesLayer_;
-(BOOL)isAxisLeftForValuesLayer:(ILAxisValuesLayer *)valuesLayer_;

-(BOOL)canDrawElementWithSize:(CGSize )elementSize_
                      atPoint:(CGPoint )point_;

@end
