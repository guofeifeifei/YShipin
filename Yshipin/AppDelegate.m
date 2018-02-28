//
//  AppDelegate.m
//  Yshipin
//
//  Created by ZZCN77 on 2017/10/12.
//  Copyright © 2017年 ZZCN77. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    return YES;
}




//这个方法会在app失去激活状态的时候调用  比如说程序进入后台

- (void)applicationWillResignActive:(UIApplication *)application {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"brightnessDefaut"] != nil) {
          [[UIScreen mainScreen] setBrightness:[[[NSUserDefaults standardUserDefaults] objectForKey:@"brightnessDefaut"] floatValue]];//0.5是自己设定认为比较合适的亮度值
    }else{
    [[UIScreen mainScreen] setBrightness: 0.5];//0.5是自己设定认为比较合适的亮度值
    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
