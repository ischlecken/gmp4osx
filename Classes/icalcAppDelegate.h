//
//  icalcAppDelegate.h
//  icalc
//
//  Created by Feldmaus on 23.10.10.
//  Copyright ischlecken.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface icalcAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> 
{
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;



@end
