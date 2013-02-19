#import <Foundation/Foundation.h>

@class ILVerticalAxisLayer;

@interface ILVerticalAxisLayerCalculator : NSObject

@property ( nonatomic, weak     ) ILVerticalAxisLayer * axisLayer;
@property ( nonatomic           ) CGFloat               heightOffset;
@property ( nonatomic           ) NSInteger             divisionsCount;
@property ( nonatomic, readonly ) CGFloat               divisionsStep;

-(void)resetState;

-(BOOL)canDrawElementWithSize:( CGSize )elementSize_
                  atYPosition:( CGFloat )yPosition_;

-(CGFloat)yPositionAtIndex:( NSUInteger )index_;
-(NSUInteger)indexByYPosition:( CGFloat )yPosition_;

-(CGPoint)positionForValueAtIndex:( NSUInteger )index_
                     withTextSize:( CGSize )textSize_;

@end
