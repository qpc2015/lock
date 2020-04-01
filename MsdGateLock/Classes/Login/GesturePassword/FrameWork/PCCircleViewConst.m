
#import "PCCircleViewConst.h"



@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key
{
//    [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [GesturePasswordModel saveGesturePassword:gesture];
}

+ (NSString *)getGestureWithKey:(NSString *)key
{
    
    return  @"无用"; //[GesturePasswordModel getGesturePassword];
   
//    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
