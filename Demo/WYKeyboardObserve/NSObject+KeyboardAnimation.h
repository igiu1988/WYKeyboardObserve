//
//  UIViewController+KeyboardAnimation.h
//  yingshibaokaoyan
//
//  Created by wangyang on 7/17/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  当键盘弹出或者收起时，会执行的block。在这个block里实现需要的UI变动
 *
 *  @param offkeyboardFrameset  将键盘转换为视图所在坐标第后，整个键盘View的Frame
 *  @param duration             动画时间
 *  @param curve                动画效果
 *  @param notification         通知
 */

typedef void(^KeyboardAnimation)(CGRect keyboardFrame, NSNotification *notifcation);
/**
 *  使用该类别，以方便的控制键盘事件
 */
@interface NSObject (KeyboardAnimation)


- (void)keyboardObserveForView:(UIView *)view movedView:(UIView *)moveView isAutoLayout:(BOOL)isAutoLayout showKeyboardAnimation:(KeyboardAnimation)showAnimation hideKeyboardAnimation:(KeyboardAnimation)hideAnimation;

// 一般情况不需要显示调用remove
- (void)removeObservKeyboard;


@end
