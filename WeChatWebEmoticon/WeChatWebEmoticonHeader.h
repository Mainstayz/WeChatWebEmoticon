//
//  WeChatWebEmoticonHeader.h
//  WeChatWebEmoticon
//
//  Created by Pillar on 2017/8/30.
//  Copyright © 2017年 unkown. All rights reserved.
//

#ifndef WeChatWebEmoticonHeader_h
#define WeChatWebEmoticonHeader_h

#import <UIKit/UIKit.h>


@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end

@interface UINavigationController (LogicController)
- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;
@end

@interface WCActionSheet:UIWindow
-(NSInteger)addButtonWithTitle:(NSString *)title;
-(NSInteger)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index;
-(NSString *)buttonTitleAtIndex:(NSInteger)index;
@end



@interface WebviewJSEventHandler_saveImage : NSObject{
    NSString *m_imgUrl;
    WCActionSheet *m_actionSheet;
}
- (id) webviewController;
- (BOOL)scanImageBySnapLocation;
- (void)actionSheet:(WCActionSheet *)sheet clickedButtonAtIndex:(NSInteger)index;

@end

@interface CBaseFile : NSObject
+ (NSString *)GetDataMD5:(NSData *)data;
@end
@interface EmoticonUtil : NSObject
+ (BOOL)saveEmoticonToEmoticonDirForMd5:(NSString *)md5 data:(NSData *)data isCleanable:(BOOL)isCleanable;
+ (id)dataOfEmoticonForMd5:(NSString *)md5;
@end

@interface CEmoticonMgr : NSObject
- (BOOL)CheckEmoticonExistInCustomListByMd5:(NSString *)md5;
@end

@interface CControlUtil : NSObject
+(id)showAlert:(id)alert message:(NSString *)msg delegate:(id)delegate cancelButtonTitle:(NSString *)canceTitle;
@end

@interface AddEmoticonWrap : NSObject
@property(nonatomic) long long source; // @synthesize source=_source;
@property(retain, nonatomic) NSString *md5;
@end


@interface EmoticonCustomManageAddLogic : NSObject
@property(nonatomic) id delegate;
- (BOOL)startAddEmoticonWithWrap:(AddEmoticonWrap *)wrap;

@end

@interface EmoticonPickViewController : UIViewController
@property(retain, nonatomic) UIImage *m_image;
@end

@interface MMWebViewController: UIViewController
@property (nonatomic, strong) EmoticonCustomManageAddLogic *addLogic;
@end

@interface MMConfigMgr: NSObject
- (NSInteger)getInputLimitEmotionBufSize;
@end

@interface CUtility: NSObject
+ (BOOL)isGIFFile:(NSData *)data;
@end


#endif /* WeChatWebEmoticonHeader_h */
