//
//  DecimalViewController.h
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecimalViewController : UIViewController

- (void) tapNumber :(UIButton *)sender;
- (void) removeTap :(UIButton *)sender;
@property (nonatomic, strong) UITextField *console;
@property NSString *opcode;
@property NSString *opPrev;
@property double firstNum;
@property double secondNum;
@end
