#import <QuartzCore/QuartzCore.h>

@protocol ILPieSliceLayerDelegate;

@interface ILPieSliceLayer : CALayer

@property ( nonatomic, weak ) id <ILPieSliceLayerDelegate> sliceDelegate;

// animated properties
@property ( nonatomic ) CGFloat startAngle;
@property ( nonatomic ) CGFloat endAngle;
@property ( nonatomic ) CGPoint center;
@property ( nonatomic ) BOOL showValue;

//EUL will use name insted
@property ( nonatomic ) NSUInteger sliceId;
@property ( nonatomic, readonly ) CGFloat radius;

@property ( nonatomic ) BOOL drawGradient;
@property ( nonatomic ) NSString* valueText;

//EUL try use style dictionary
@property ( nonatomic ) UIColor* fillColor;
@property ( nonatomic ) UIFont*  valuesFont;
@property ( nonatomic ) CGFloat animationDuration;

@end
