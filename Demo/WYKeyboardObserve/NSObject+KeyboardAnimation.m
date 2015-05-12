//
//  UIViewController+KeyboardAnimation.m
//  yingshibaokaoyan
//
//  Created by wangyang on 7/17/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import "NSObject+KeyboardAnimation.h"
#import <objc/runtime.h>


@interface NSObject ()
@property (nonatomic, strong) UIView *wy_targetView;
@property (nonatomic, strong) UIView *wy_movedView;
@property (nonatomic, assign) BOOL wy_isAutoLayout;
@property (nonatomic, copy) KeyboardAnimation wy_showAnimationblock;
@property (nonatomic, copy) KeyboardAnimation wy_hideAnimationblock;

@end

@implementation NSObject (KeyboardAnimation)



#pragma mark - 属性get、set
- (UIView *)wy_targetView
{
    return objc_getAssociatedObject(self, NSSelectorFromString(@"wy_targetView"));
}
- (void)setWy_targetView:(UIView *)wy_targetView
{
    objc_setAssociatedObject(self, NSSelectorFromString(@"wy_targetView"), wy_targetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)wy_movedView
{
    return objc_getAssociatedObject(self, NSSelectorFromString(@"wy_movedView"));
}
- (void)setWy_movedView:(UIView *)wy_movedView
{
    objc_setAssociatedObject(self, NSSelectorFromString(@"wy_movedView"), wy_movedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)wy_isAutoLayout
{
    return [objc_getAssociatedObject(self, NSSelectorFromString(@"wy_isAutoLayout")) boolValue];
}
- (void)setWy_isAutoLayout:(BOOL)wy_isAutoLayout
{
    NSNumber *number = [NSNumber numberWithBool:wy_isAutoLayout];
    objc_setAssociatedObject(self, NSSelectorFromString(@"wy_isAutoLayout"), number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (KeyboardAnimation)wy_showAnimationblock
{
    return objc_getAssociatedObject(self, NSSelectorFromString(@"wy_showAnimationblock"));
}

- (void)setWy_showAnimationblock:(KeyboardAnimation)wy_showAnimationblock
{
    objc_setAssociatedObject(self, NSSelectorFromString(@"wy_showAnimationblock"), wy_showAnimationblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardAnimation)wy_hideAnimationblock
{
    return objc_getAssociatedObject(self, NSSelectorFromString(@"wy_hideAnimationblock"));
}

- (void)setWy_hideAnimationblock:(KeyboardAnimation)wy_hideAnimationblock
{
    objc_setAssociatedObject(self, NSSelectorFromString(@"wy_hideAnimationblock"), wy_hideAnimationblock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 监听
// 不同情况，要移动的view基本不一样，moved view，animate block, isAutoLayout

- (void)keyboardObserveForView:(UIView *)view movedView:(UIView *)moveView isAutoLayout:(BOOL)isAutoLayout showKeyboardAnimation:(KeyboardAnimation)showAnimation hideKeyboardAnimation:(KeyboardAnimation)hideAnimation
{
    self.wy_targetView = view;
    self.wy_movedView = moveView;
    self.wy_isAutoLayout = isAutoLayout;
    self.wy_showAnimationblock = showAnimation;
    self.wy_hideAnimationblock = hideAnimation;
    
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
    self.wy_showAnimationblock = nil;
    self.wy_targetView = nil;
    self.wy_hideAnimationblock = nil;
    self.wy_targetView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 监听响应
- (void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardFrame;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardFrame];
    // Need to translate the bounds to account for rotation.
    keyboardFrame = [[UIApplication sharedApplication].keyWindow convertRect:keyboardFrame toView:self.wy_targetView.superview];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    if (self.wy_isAutoLayout) {
        self.wy_showAnimationblock(keyboardFrame, note);
        [UIView animateWithDuration:[duration doubleValue] delay:0 options:[curve doubleValue] animations:^{
            [self.wy_targetView.superview layoutIfNeeded];
            
        } completion:NULL];
    }else{
        [UIView animateWithDuration:[duration doubleValue] delay:0 options:[curve doubleValue] animations:^{
            self.wy_showAnimationblock(keyboardFrame, note);

        } completion:NULL];
    }
}

- (void)keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    if (self.wy_isAutoLayout) {
        
        if (self.wy_hideAnimationblock) {
            self.wy_hideAnimationblock(CGRectZero, note);
        }
        
        [UIView animateWithDuration:[duration doubleValue] delay:0 options:[curve doubleValue] animations:^{
            [self.wy_targetView.superview layoutIfNeeded];
            
        } completion:NULL];
    }else{
        [UIView animateWithDuration:[duration doubleValue] delay:0 options:[curve doubleValue] animations:^{
            if (self.wy_hideAnimationblock) {
                self.wy_hideAnimationblock(CGRectZero, note);
            }
            
            
        } completion:NULL];
    }
    
    
}
@end
