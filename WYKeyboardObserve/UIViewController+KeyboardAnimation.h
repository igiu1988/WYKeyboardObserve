//
//  UIViewController+KeyboardAnimation.h
//  yingshibaokaoyan
//
//  Created by wangyang on 7/17/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  当键盘弹出或者收起时，会执行的block
 *
 *  @param object              self自己
 *  @param targeMoveViewEndTop 目标移动view最终位置的y坐标
 *  @param offset              对应事件所造成的偏移
 *  @param notification        通知：UIKeyboardWillShowNotification 或者 UIKeyboardWillHideNotification
 */
typedef void(^KeyboardAnimationBlock)(id object, CGFloat targeMoveViewEndTop, CGFloat offset, NSString *const notification);

/**
 *  使用该类别，以方便的控制键盘事件及对应textView，view的位置处理
 */
@interface UIViewController (KeyboardAnimation)

/**
 *  参考视图，键盘的top会与这个视图的bottom进行对比，以决定targeMoveView是否需要移动
 */

@property (nonatomic, strong) UIView *referView;

@property (nonatomic, readonly) KeyboardAnimationBlock animationblock;


/**
 *  被移动视图
 *  需要移动的view，可能是referView本身，也可能是inputView.superView，或者其它。
 */
@property (nonatomic, strong) UIView *targeMoveView;


/**
 *  必须在viewWillApperar或者viewDidApperar里调用，才可以正常监听
 *
 *  @param offset       动画时的偏移量
 *  @param notification 通知名
 */
- (void)observeKeyboardWithAnimation:(KeyboardAnimationBlock)animationblock;

/**
 *  必须在viewWillDisapperar或者viewDidDisapperar里调用，才可以移除监听
 */
- (void)removeObservKeyboard;


@end
