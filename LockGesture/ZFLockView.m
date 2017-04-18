//
//  ZFLockView.m
//  LockGesture
//
//  Created by HZhenF on 2017/4/18.
//  Copyright © 2017年 Huangzhengfeng. All rights reserved.
//

#import "ZFLockView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/**三列*/
int const column = 3;
/**三行*/
int const row = 3;
/**按钮宽度*/
CGFloat const btnW = 74;
/**按钮高度*/
CGFloat const btnH = 74;

@interface ZFLockView()

/**临时保存的点*/
@property(nonatomic,assign) CGPoint currentPoint;

@end

@implementation ZFLockView

#pragma mark - lazy load

-(NSMutableArray<UIButton *> *)btnArrM
{
    if (!_btnArrM) {
        _btnArrM = [NSMutableArray array];
    }
    return _btnArrM;
}

#pragma mark - System method

-(void)layoutBtn
{
    CGFloat marginX = (ScreenWidth - (btnW*column))/(column + 1);
    CGFloat marginY = (ScreenHeight * 0.8 - (btnH*row))/(row + 1);
    for (int i = 0; i < column*row; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        btn.tag = i;
        //必须要关闭按钮的交互，否则无法获取他的touches事件
        btn.userInteractionEnabled = NO;
        
        int specificRow = i / column;
        int specifiColumn = i % column;
        CGFloat x = marginX + specifiColumn*(btnW + marginX);
        CGFloat y = marginY + specificRow*(btnH + marginY);
        btn.frame = CGRectMake(x, y, btnW, btnH);
        [self addSubview:btn];
    }
    self.frame = CGRectMake(0, ScreenHeight*0.1, ScreenWidth, ScreenHeight * 0.8);
}

-(void)drawRect:(CGRect)rect
{

    if (self.btnArrM.count == 0) {
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound;
    [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] set];
    path.lineWidth = 8;
    
    for (int i = 0; i < self.btnArrM.count;i ++) {
        UIButton *btn = self.btnArrM[i];
        if(i == 0)
        {
            [path moveToPoint:btn.center];
        }
        else
        {
            [path addLineToPoint:btn.center];
        }
    }
    //使用临时的点是为了演示:连了一个点后，还可以把线拖出来
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取当前触摸的点
    CGPoint currentPoint = [self pointWithTouch:touches];
    //判断这个点在不在按钮上,在的话就选中当前按钮
    UIButton *btn = [self buttonWithPoint:currentPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.btnArrM addObject:btn];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [self pointWithTouch:touches];
    UIButton *btn = [self buttonWithPoint:currentPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.btnArrM addObject:btn];
    }
    else
    {
        self.currentPoint = currentPoint;
    }
    //drawRect方法会被调用
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString *path = [NSMutableString string];
        for (UIButton *btn in self.btnArrM) {
            [path appendFormat:@"%ld",(long)btn.tag];
        }
        [self.delegate lockView:self didFinishPath:path];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutBtn];
    }
    return self;
}


#pragma mark - encapsulateMethod(封装方法)

/**判断这个点在不在按钮上*/
-(UIButton *)buttonWithPoint:(CGPoint)currentPoint
{
    for (UIButton *btn  in self.subviews) {
        if (CGRectContainsPoint(btn.frame, currentPoint)) {
            return btn;
        }
    }
    return nil;
}

/**获取当前触摸的点*/
-(CGPoint)pointWithTouch:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    return currentPoint;
}











@end
