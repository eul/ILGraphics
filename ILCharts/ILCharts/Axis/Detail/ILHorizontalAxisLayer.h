#import "ILAxisLayer.h"

@interface ILHorizontalAxisLayer : ILAxisLayer

@property ( nonatomic, readonly ) CGFloat fontSize;
@property ( nonatomic, readonly ) CGFloat widthOffset;
@property ( nonatomic, readonly ) CGFloat startYForBigDivision;
@property ( nonatomic, readonly ) CGFloat endYForBigDivision;

-(BOOL)canDrawLineAtPoint:( CGFloat )currX_;

-(void)drawHorizontalLineInContect:( CGContextRef )context_;

-(CGFloat)yPositionForValueWithTextSize:( CGSize )textSize_;

@end
