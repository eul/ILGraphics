#import <Foundation/Foundation.h>

@class ILAxis;

@protocol ILAxisDelegate <NSObject>

@required
-(NSInteger)numberOfPointsForAxis:(ILAxis *)axis_;

-(NSString*)axis:(ILAxis *)axis_
labelTextForPoint:(NSInteger )point_;

@optional
/// Tap handling

-(void)axis:(ILAxis *)axis_
didTapPoint:(CGPoint )point_
    atIndex:(NSInteger )index_;

///Offset methods

-(BOOL)useCenteredOffsetForAxis:(ILAxis *)axis_;

-(BOOL)useCenteredOffsetForValuesInAxis:(ILAxis *)axis_;

///Skin

-(CGFloat)labelsRotationAngleInDegreesForAxis:(ILAxis *)axis_;

-(UIColor*)colorForAxis:(ILAxis *)axis_;

-(CGFloat)widthForAxis:(ILAxis *)axis_;

-(UIColor*)backgroundColorForAxis:(ILAxis *)axis_;

-(UIColor*)shortDivisionsColorForAxis:(ILAxis *)axis_;

-(CGFloat)shortDivisionsLengthForAxis:(ILAxis *)axis_;

-(CGFloat)shortDivisionsWidthForAxis:(ILAxis *)axis_;

-(CGFloat)bigDivisionsLengthForAxis:(ILAxis *)axis_;

-(CGFloat)bigDivisionsWidthForAxis:(ILAxis *)axis_;

-(UIColor*)bigDivisionsColorForAxis:(ILAxis *)axis_;

-(UIFont*)axis:(ILAxis *)axis_
fontForLabelAtPoint:(NSInteger )point_;

-(UIColor*)axis:(ILAxis *)axis_
colorForLabelAtPoint:(NSInteger )point_;

@end
