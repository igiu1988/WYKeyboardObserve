//
//  UIViewController+KeyboardObserve.h
//  yingshibaokaoyan
//
//  Created by wangyang on 7/17/14.
//  Copyright (c) 2014 com.zkyj.yingshibao.kaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  当键盘弹出或者收起时，会执行的block
 *
 *  @param controller          self自己
 *  @param targeMoveViewEndTop targeMoveView最终位置的y坐标
 *  @param offset              对应事件所造成的偏移
 *  @param notification        事件通知：UIKeyboardWillShowNotification 或者 UIKeyboardWillHideNotification
 */
typedef void(^KeyboardObserveBlock)(id controller, CGFloat targeMoveViewEndTop, CGFloat offset, NSString *const notification);

/**
 *  使用该类别，以方便的控制键盘事件及对应textView，view的位置处理
 */
@interface UIViewController (KeyboardObserve)

/**
 *  参考视图
 *  targeMoveView会移动多少取决于这个view。键盘的top会与这个视图的bottom进行对比，以决定targeMoveView是否需要移动
 *  对于view层级比较简单的情况下，targeMoveView与referView有可能是一个view
 */
@property (nonatomic, strong) UIView *referView;

/**
 *  被移动视图
 *  有可能是UITextView或者UITextField这种inputView，也有可能是包含inputView的container view。
 *  对于view层级比较简单的情况下，targeMoveView与referView有可能是一个view
 */
@property (nonatomic, strong) UIView *targeMoveView;


/**
 *  必须在viewWillApperar或者viewDidApperar里调用，才可以正常监听
 *
 *  @param animationblock 在键盘出现、收回时会执行该block
 */
- (void)addObserveKeyboardWithAnimation:(KeyboardObserveBlock)observeBlock;

/**
 *  必须在viewWillDisapperar或者viewDidDisapperar里调用，才可以移除监听
 */
- (void)removeObservKeyboard;


@end
