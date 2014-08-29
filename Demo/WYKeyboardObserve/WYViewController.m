//
//  WYViewController.m
//  WYKeyboardObserve
//
//  Created by wangyang on 8/28/14.
//  Copyright (c) 2014 com.wy. All rights reserved.
//

#import "WYViewController.h"
#import "UIViewController+KeyboardObserve.h"

@interface WYViewController () <UITextFieldDelegate>
{
    __weak IBOutlet UIView *container;
    __weak IBOutlet UITextField *textField1;
    __weak IBOutlet UIButton *button;
    
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
    [self addObserveKeyboardWithAnimation:^(id controller, CGFloat targeMoveViewEndTop, CGFloat offset, NSString *const notification) {
        NSLog(@"%@: 目标view将要移动到的y坐标%f\n，偏移量:%f", notification, targeMoveViewEndTop, offset);
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
    if (textField1 == textField){
        self.targeMoveView = container;
        self.referView = button;
    }else{
        self.targeMoveView = textField2;
        self.referView = textField2;
    }
    
    return YES;
    
}

@end
