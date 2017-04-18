//
//  ZFLockView.h
//  LockGesture
//
//  Created by HZhenF on 2017/4/18.
//  Copyright © 2017年 Huangzhengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFLockView;
@protocol ZFLockViewDelegate <NSObject>

-(void)lockView:(ZFLockView *)lockView didFinishPath:(NSString *)path;

@end

@interface ZFLockView : UIView

@property(nonatomic,assign) id <ZFLockViewDelegate> delegate;

/**选中按钮集合*/
@property(nonatomic,strong) NSMutableArray<UIButton *> *btnArrM;

@end
