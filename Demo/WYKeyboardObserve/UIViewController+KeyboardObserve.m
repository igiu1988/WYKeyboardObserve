//
//  UIViewController+KeyboardObserve.m
//  yingshibaokaoyan
//
//  Created by wangyang on 7/17/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import "UIViewController+KeyboardObserve.h"
#import <objc/runtime.h>

static const char kOffset;
static const char kReferView;
static const char kTargeMoveView;
static const char kObserveBlock;

@interface UIViewController ()
{
    
}
@property (nonatomic, copy) KeyboardObserveBlock observeBlock;
@property (nonatomic, assign) float offset;
@end

@implementation UIViewController (KeyboardObserve)
@dynamic referView;
@dynamic targeMoveView;


#pragma mark - 属性getter、setter

- (float)offset
{
    NSNumber *number = objc_getAssociatedObject(self, &kOffset);
    
    return [number floatValue];
}

- (void)setOffset:(float)offset
{
    objc_setAssociatedObject(self, &kOffset, [NSNumber numberWithFloat:offset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)referView
{
    return objc_getAssociatedObject(self, &kReferView);
}

- (void)setReferView:(UIView *)inputView
{
    objc_setAssociatedObject(self, &kReferView, inputView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KeyboardObserveBlock)observeBlock
{
    return objc_getAssociatedObject(self, &kObserveBlock);
}

- (void)setObserveBlock:(KeyboardObserveBlock)observeBlock
{
    objc_setAssociatedObject(self, &kObserveBlock, observeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)targeMoveView
{
    return objc_getAssociatedObject(self, &kTargeMoveView);
}

- (void)setTargeMoveView:(UIView *)targeMoveView
{
    objc_setAssociatedObject(self, &kTargeMoveView, targeMoveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 监听

- (void)addObserveKeyboardWithAnimation:(KeyboardObserveBlock)block
{
    self.observeBlock = block;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeObservKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 响应


- (void)keyboardWillShow:(NSNotification *)note{
    // 取得键盘的frame，将该frame转换到self.referView的坐标系
	CGRect keyboardFrame;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardFrame];
    keyboardFrame = [[UIApplication sharedApplication].keyWindow convertRect:keyboardFrame toView:self.referView.superview];
    
    // 用keyboard的y坐标减去inputView的底部坐标，得到offset
    self.offset = keyboardFrame.origin.y - (self.referView.frame.size.height + self.referView.frame.origin.y);
    
    // self.offset >= 0 ，说明inputView完全在键盘上面，不需要移动
    if (self.offset >= 0 ) {
        return;
    }
    
    if (self.observeBlock) {
        CGFloat targeMoveViewEndTop = self.targeMoveView.frame.origin.y + self.offset;
        self.observeBlock(self, targeMoveViewEndTop, self.offset, UIKeyboardWillShowNotification);
    }
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue]
                         animations:^{
                             CGRect frame = self.targeMoveView.frame;
                             frame.origin.y += self.offset;
                             self.targeMoveView.frame = frame;
                        }];

}

- (void)keyboardWillHide:(NSNotification *)note{
    
    CGAffineTransform currentTransform = self.targeMoveView.transform;
    CGFloat targeMoveViewEndTop = self.targeMoveView.frame.origin.y - currentTransform.ty;
    
    if (self.observeBlock) {
        self.observeBlock(self, targeMoveViewEndTop, currentTransform.ty, UIKeyboardWillHideNotification);
    }
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue]
                     animations:^{
                         CGRect frame = self.targeMoveView.frame;
                         frame.origin.y -= self.offset;
                         self.targeMoveView.frame = frame;
                     }];
}
@end
