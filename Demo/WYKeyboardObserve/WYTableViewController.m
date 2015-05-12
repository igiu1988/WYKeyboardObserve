//
//  WYTableViewController.m
//  WYKeyboardObserve
//
//  Created by wangyang on 1/7/15.
//  Copyright (c) 2015 com.wy. All rights reserved.
//

#import "WYTableViewController.h"

@interface WYTableViewController ()
{
    __weak IBOutlet UITextField *textField;
}
@end

@implementation WYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.referView = textField;
//    self.targeMoveView = self.tableView;
//    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
@end
