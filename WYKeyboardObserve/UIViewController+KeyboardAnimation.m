//
//  UIViewController+KeyboardAnimation.m
//  yingshibaokaoyan
//
//  Created by wangyang on 7/17/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import "UIViewController+KeyboardAnimation.h"
#import <objc/runtime.h>

static const char kInputView;
static const char kTargeMoveView;
static const char kAnimationblock;

@interface UIViewController ()
{
}
@end

@implementation UIViewController (KeyboardAnimation)
@dynamic referView;
@dynamic targeMoveView;


#pragma mark - 属性get、set

- (KeyboardAnimationBlock)animationblock
{
    return objc_getAssociatedObject(self, &kAnimationblock);
}

- (void)setAnimationblock:(KeyboardAnimationBlock)animationblock
{
    objc_setAssociatedObject(self, &kAnimationblock, animationblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)referView
{
    return objc_getAssociatedObject(self, &kInputView);
}

- (void)setReferView:(UIView *)inputView
{
    objc_setAssociatedObject(self, &kInputView, inputView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (void)observeKeyboardWithAnimation:(KeyboardAnimationBlock)block
{
    self.animationblock = block;
    
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


#pragma mark - 监听响应


- (void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardFrame;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardFrame];
    // Need to translate the bounds to account for rotation.
    keyboardFrame = [[UIApplication sharedApplication].keyWindow convertRect:keyboardFrame toView:self.referView.superview];
    
    // 用keyboard的y坐标减去inputView的底部坐标，得到offset
    CGFloat offset = keyboardFrame.origin.y - (self.referView.frame.size.height + self.referView.frame.origin.y);
    
    // offset >= 0 ，说明inputView完全在键盘上面，不需要移动
    if (offset >= 0 ) {
        return;
    }
    
    
    if (self.animationblock) {
        CGFloat targeMoveViewEndTop = self.targeMoveView.top + offset;
        self.animationblock(self, targeMoveViewEndTop, offset, UIKeyboardWillShowNotification);
    }
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:[duration intValue]
                          delay:0
                        options:[curve intValue] >> 16
                     animations:^{
//                            self.targeMoveView.transform = CGAffineTransformMakeTranslation(0, offset);
                         self.targeMoveView.transform = CGAffineTransformTranslate(self.targeMoveView.transform, 0, offset);
                        }
                     completion:NULL];

}

- (void)keyboardWillHide:(NSNotification *)note{
    
    CGAffineTransform currentTransform = self.targeMoveView.transform;
    CGFloat targeMoveViewEndTop = self.targeMoveView.top - currentTransform.ty;
    
    if (self.animationblock) {
        self.animationblock(self, targeMoveViewEndTop, currentTransform.ty, UIKeyboardWillHideNotification);
    }
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

	self.targeMoveView.transform = CGAffineTransformIdentity;

	[UIView commitAnimations];
}
@end
