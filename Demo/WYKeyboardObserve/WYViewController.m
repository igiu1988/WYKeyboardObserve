//
//  WYViewController.m
//  WYKeyboardObserve
//
//  Created by wangyang on 8/28/14.
//  Copyright (c) 2014 com.wy. All rights reserved.
//

#import "WYViewController.h"
#import "NSObject+KeyboardAnimation.h"
#import "UIView+Utils.h"


@interface WYViewController () <UITextFieldDelegate>
{
    __weak IBOutlet UIView *container;
    __weak IBOutlet UITextField *textField1;
    __weak IBOutlet UIButton *button;
    __weak IBOutlet NSLayoutConstraint *containerBottomConstraint;
    
    __weak IBOutlet UITextField *textField2;
}
@end

@implementation WYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 不同情况，要移动的view基本不一样，moved view，animate block, isAutoLayout,
    [self keyboardObserveForView:button movedView:container isAutoLayout:YES showKeyboardAnimation:^(CGRect keyboardFrame, NSNotification *notifcation) {
        if (keyboardFrame.origin.y >= button.bottom) {
            return ;
        }
        
        float offset = button.bottom - keyboardFrame.origin.y;
        containerBottomConstraint.constant += offset;
    } hideKeyboardAnimation:^(CGRect keyboardFrame, NSNotification *notifcation) {
        containerBottomConstraint.constant = 20;
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObservKeyboard];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
    
}

@end
