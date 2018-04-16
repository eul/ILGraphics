#import <QuartzCore/QuartzCore.h>

@interface ILAxisValueLayer : CALayer

@property (nonatomic) NSString *text;
@property (nonatomic) UIFont   *font;
@property (nonatomic) UIColor  *textColor;
@property (nonatomic) CGFloat   rotationAngle;

@end
