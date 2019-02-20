//
//  BaoAppDelegate.h
//  Qihuo
//
//  Created by 江承諭 on 2017/11/13.
//  Copyright © 2017年 DongDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaoAppDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;

- (void)jpushInitialize:(NSDictionary *)launchOptions withAppKey:(NSString *)appKey;

@end
