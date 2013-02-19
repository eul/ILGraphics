#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@protocol ILLayer <NSObject>

@required
- (void)reloadData;
- (void)reloadDataInRect:(CGRect)rect
               scrolling:(BOOL)scrolling;

- (void)reloadDataAnimated:(BOOL)animated;

- (void)hadleTapAtPoint:(CGPoint)tapPoint;

@end

@interface ILLayer : ILLayer <ILLayer>

@end
