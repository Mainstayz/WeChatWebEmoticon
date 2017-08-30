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
#import "WeChatWebEmoticonHeader.h"

CHDeclareClass(MMWebViewController)

CHProperty(MMWebViewController, EmoticonCustomManageAddLogic *, addLogic, setAddLogic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

CHDeclareClass(WebviewJSEventHandler_saveImage)
CHOptimizedMethod(0,self, BOOL, WebviewJSEventHandler_saveImage, scanImageBySnapLocation){
    WCActionSheet *sheet = CHIvar(self, m_actionSheet, __strong WCActionSheet *);
    [sheet addButtonWithTitle:@"保存为表情"];
    return CHSuper(0,WebviewJSEventHandler_saveImage, scanImageBySnapLocation);
}

CHOptimizedMethod(2,self, void, WebviewJSEventHandler_saveImage, actionSheet,WCActionSheet*,sheet,clickedButtonAtIndex,NSInteger,index){
    CHSuper(2,WebviewJSEventHandler_saveImage, actionSheet,sheet,clickedButtonAtIndex,index);
    NSString *title = [sheet buttonTitleAtIndex:index];
    if ([title isEqualToString:@"保存为表情"]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *imgUrl = CHIvar(self, m_imgUrl, __strong NSString*);
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            
            if (imgData) {
                
                BOOL isGif = [objc_getClass("CUtility") isGIFFile:imgData];
                
                // 如果是Gif动态图
                if (isGif){
                    
                    NSString *md5 = [objc_getClass("CBaseFile") GetDataMD5:imgData];
                    
                    //保存在本地
                    if ([objc_getClass("EmoticonUtil") saveEmoticonToEmoticonDirForMd5:md5 data:imgData isCleanable:YES]) {
                        
                        CEmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CEmoticonMgr") class]];
                        
                        // 检查本地是否存在
                        if ([emoticonMgr CheckEmoticonExistInCustomListByMd5:md5]) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [objc_getClass("CControlUtil") showAlert:nil message:@"表情已存在" delegate:nil cancelButtonTitle:nil];
                            });
                            
                        }else{
                            
                            // 否则上传服务器
                            dispatch_async(dispatch_get_main_queue(), ^{
                                AddEmoticonWrap *wrap = [[objc_getClass("AddEmoticonWrap") alloc] init];
                                wrap.source = 1;
                                wrap.md5 = md5;
                                EmoticonCustomManageAddLogic* addlogic =  [[objc_getClass("EmoticonCustomManageAddLogic") alloc] init];
                                [(MMWebViewController *)self.webviewController setAddLogic:addlogic];
                                [addlogic startAddEmoticonWithWrap:wrap];
                                
                            });
                            
                        }
                    }
                }else{
                    
                    // 如果是静态图
                    UIImage *image = [UIImage imageWithData:imgData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        EmoticonPickViewController *pickViewController = [[objc_getClass("EmoticonPickViewController") alloc] init];
                        pickViewController.m_image = image;
                        MMWebViewController *webViewController =  (MMWebViewController *)self.webviewController;
                        [webViewController.navigationController PushViewController:pickViewController animated:YES];
                    });
                }
                
            }else{
                // 获取不到图片数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [objc_getClass("CControlUtil") showAlert:nil message:@"图片数据为空" delegate:nil cancelButtonTitle:nil];
                });
            }
        });
        
    }
    
}



CHDeclareClass(MMConfigMgr)

CHOptimizedMethod(0,self, NSInteger,MMConfigMgr,getInputLimitEmotionBufSize){
    
    // 突破微信gif大小限制，这里改为是  原来（1048576Byte = 1M）的2倍（即2M），足够收藏大多数gif表情了。
    NSInteger bufSize =  CHSuper(0,MMConfigMgr, getInputLimitEmotionBufSize);
    bufSize = bufSize * 2;
    return bufSize;
}

CHConstructor{
    CHLoadLateClass(WebviewJSEventHandler_saveImage);
    CHClassHook(0,WebviewJSEventHandler_saveImage, scanImageBySnapLocation);
    CHClassHook(2,WebviewJSEventHandler_saveImage, actionSheet,clickedButtonAtIndex);
    
    
    CHLoadLateClass(MMWebViewController);
    CHClassHook(0,MMWebViewController, addLogic);
    CHClassHook(1,MMWebViewController, setAddLogic);
    
    
    CHLoadLateClass(MMConfigMgr);
    CHClassHook(0,MMConfigMgr,getInputLimitEmotionBufSize);

}
