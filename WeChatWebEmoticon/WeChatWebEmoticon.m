//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  WeChatWebEmoticon.m
//  WeChatWebEmoticon
//
//  Created by Pillar on 2017/8/30.
//  Copyright (c) 2017年 unkown. All rights reserved.
//

#import "WeChatWebEmoticon.h"
#import "CaptainHook.h"
#import <UIKit/UIKit.h>

CHDeclareClass(CustomViewController)

CHOptimizedMethod(0, self, NSString*, CustomViewController,getMyName){
    return @"MonkeyDevPod";
}

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook(0, CustomViewController, getMyName);
}
