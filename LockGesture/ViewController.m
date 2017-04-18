//
//  ViewController.m
//  LockGesture
//
//  Created by HZhenF on 2017/4/18.
//  Copyright © 2017年 Huangzhengfeng. All rights reserved.
//

#import "ViewController.h"
#import "ZFLockView.h"

//默认密码
#define customPassword @"03678"

@interface ViewController ()<ZFLockViewDelegate>

@property(nonatomic,strong)ZFLockView *zfLockView;

@end

@implementation ViewController

#pragma mark - System method

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"bg.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    

    ZFLockView *zfView = [[ZFLockView alloc] init];
    zfView.backgroundColor = [UIColor clearColor];
    zfView.delegate = self;
    [self.view addSubview:zfView];
    
    self.zfLockView = zfView;
}

#pragma mark - ZFLockViewDelegate

-(void)lockView:(ZFLockView *)lockView didFinishPath:(NSString *)path
{
    if ([path isEqualToString:customPassword]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码正确" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.zfLockView.btnArrM removeAllObjects];
            for (UIButton *btn in self.zfLockView.subviews) {
                btn.selected = NO;
            }
            [self.zfLockView setNeedsDisplay];
        }]];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.zfLockView.btnArrM removeAllObjects];
            for (UIButton *btn in self.zfLockView.subviews) {
                btn.selected = NO;
            }
            [self.zfLockView setNeedsDisplay];

        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

@end
