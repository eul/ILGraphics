#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

typedef enum
{
    ILAxisOrientationHorizontal,
    ILAxisOrientationVertical
} ILAxisOrientation;

typedef enum
{
    ILAxisGravityLeft,
    ILAxisGravityRight,
    ILAxisGravityNone
} ILAxisGravity;

@protocol ILAxisDelegate;

@protocol ILAxis < NSObject >

@required
@property ( nonatomic, weak ) id < ILAxisDelegate > delegate;

@property ( nonatomic ) float size;
@property ( nonatomic ) ILAxisOrientation orientation;
@property ( nonatomic ) ILAxisGravity     gravity;

@property ( nonatomic ) BOOL drawShortDelimiters;

@end

@interface ILAxis : NSObject < ILAxis >

@property ( nonatomic, weak ) id < ILAxisDelegate > delegate;

@property ( nonatomic ) float size;
@property ( nonatomic ) ILAxisOrientation orientation;
@property ( nonatomic ) ILAxisGravity gravity;

@property ( nonatomic ) BOOL drawShortDelimiters;

@end
