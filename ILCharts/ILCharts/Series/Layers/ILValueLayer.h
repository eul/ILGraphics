#import <QuartzCore/QuartzCore.h>

@interface ILValueLayer : CALayer

@property (nonatomic) NSString *text;
@property (nonatomic) UIFont   *font;
@property (nonatomic) UIColor  *textColor;
@property (nonatomic) BOOL      showVertical;

@end
